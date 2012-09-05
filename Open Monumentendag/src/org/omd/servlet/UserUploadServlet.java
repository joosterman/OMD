package org.omd.servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.omd.User;
import org.omd.UserImage;
import org.omd.Utility;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.blobstore.UploadOptions;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;
import com.google.appengine.api.images.ServingUrlOptions;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class UserUploadServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 3797112498898340101L;
	private UploadOptions uploadOptions = UploadOptions.Builder.withMaxUploadSizeBytesPerBlob(4 * 1024 * 1024);
	private Objectify ofy = ObjectifyService.begin();
	private ImagesService imagesService = ImagesServiceFactory.getImagesService();
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	private Logger logger = java.util.logging.Logger.getLogger("UserUpload");

	/**
	 * Handles the upload of an image by a user
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		// Is a blob uploaded?
		Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(request);
		List<BlobKey> blobKeys = blobs.get("userImage");
		BlobKey blobKey = null;
		if (blobKeys == null || blobKeys.size() == 0)
			blobKey = blobKeys.get(0);
		// is there a return path?
		String path = request.getParameter("path");
		logger.warning("return path:"+ path);
		String key = request.getParameter("key");
		Long userID = Utility.parseLong(request.getParameter("userID"));
		Long locationID = Utility.parseLong(request.getParameter("locationID"));

		// get user if able
		User u = null;
		if (userID != null && key != null)
			u = ofy.query(User.class).filter("id", userID).filter("key", key).get();

		// check if the file is a image
		try {
			if (u != null && locationID != null && blobKey != null) {
				ServingUrlOptions opts = ServingUrlOptions.Builder.withBlobKey(blobKey);
				String url = imagesService.getServingUrl(opts);

				UserImage ui = new UserImage();
				ui.locationID = locationID;
				ui.userID = userID;
				ui.blobKey = blobKey;
				ui.imageURL = url;
				ofy.put(ui);
			}

		}
		catch (Exception ex) {
		}
		response.sendRedirect(String.format("#detail?id=%s", locationID));

	}

	/**
	 * Returns a new fileUploadURL to the blobStorage
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String path = request.getParameter("path");
		Long userID = Utility.parseLong(request.getParameter("userID"));
		Long locationID = Utility.parseLong(request.getParameter("locationID"));
		String key = request.getParameter("key");

		// load user if able
		User user = null;
		if (userID != null && key != null)
			user = ofy.query(User.class).filter("id", userID).filter("key", key).get();

		if (path == null || user == null || locationID == null) {
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
		else {
			String url = blobstoreService.createUploadUrl(String.format("/userUpload?key=%s&userID=%s&locationID=%s&path=%s", key, userID, locationID, path), uploadOptions);
			response.getWriter().write(Utility.gson.toJson(url));
		}

	}
}
