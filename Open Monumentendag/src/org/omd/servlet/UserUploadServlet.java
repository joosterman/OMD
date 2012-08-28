package org.omd.servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.omd.User;
import org.omd.UserImage;
import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.blobstore.UploadOptions;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;
import com.google.appengine.api.images.ServingUrlOptions;
import com.google.gson.Gson;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class UserUploadServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 3797112498898340101L;
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	private UploadOptions uploadOptions = UploadOptions.Builder.withMaxUploadSizeBytesPerBlob(4 * 1024 * 1024);
	private Gson gson = new Gson();
	private Objectify ofy = ObjectifyService.begin();
	private ImagesService imagesService = ImagesServiceFactory.getImagesService();

	/**
	 * Handles the upload of an image by a user
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		boolean correct = true;
		//get parameters and check validity
		
		// Is a blob uploaded?
		Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(request);
		List<BlobKey> blobKeys = blobs.get("userImage");
		if (blobKeys == null || blobKeys.size() == 0) correct = false;
		BlobKey blobKey = blobKeys.get(0);
		// is there a return path?
		String path = request.getParameter("path");
		if (path == null) correct = false;
		String key = request.getParameter("key");
		// Are the ID parameters correct
		String s_userID = request.getParameter("userID");
		String s_locationID = request.getParameter("locationID");
		Long userID = null;
		Long locationID = null;
		try {
			userID = Long.parseLong(s_userID);
			locationID = Long.parseLong(s_locationID);
		}
		catch (NumberFormatException ex) {
			correct = false;
		}
		// does user exist?
		User u = ofy.query(User.class).filter("id", userID).filter("key", key).get();
		if (u == null) correct = false;
		
		//check if the file is a image
		try{
			ServingUrlOptions opts = ServingUrlOptions.Builder.withBlobKey(blobKey);				
			imagesService.getServingUrl(opts);
		}
		catch(Exception ex){
			correct = false;
		}

		//send error or upload 
		if (!correct) {
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
		else {
			UserImage ui = new UserImage();
			ui.adminApproved = false;
			ui.locationID = locationID;
			ui.userID = userID;
			ui.blobKey = blobKey;
			ofy.put(ui);
			response.sendRedirect(String.format("%s?id=%s",path,s_locationID));
		}
	}

	/**
	 * Returns a new fileUploadURL to the blobStorage
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String path = request.getParameter("path");
		String userID = request.getParameter("userID");
		String locationID = request.getParameter("locationID");
		String key = request.getParameter("key");
		if (path == null || userID == null || locationID == null) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
		}
		else {
			String url = blobstoreService.createUploadUrl(
					String.format("/userUpload?key=%s&userID=%s&locationID=%s&path=%s", key, userID, locationID, path), uploadOptions);
			response.getWriter().write(gson.toJson(url));
		}

	}
}
