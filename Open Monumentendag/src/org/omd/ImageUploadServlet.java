package org.omd;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;
import com.google.appengine.api.images.ServingUrlOptions;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class ImageUploadServlet extends HttpServlet {

	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	private ImagesService imagesService = ImagesServiceFactory.getImagesService();
	private static final Logger log = Logger.getLogger(ImageUploadServlet.class.getName());
	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		Objectify ofy = ObjectifyService.begin();
		Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(request);
		Long id = null;
		try {
			id = Long.valueOf(request.getParameter("id"));
		}
		catch (Exception ex) {
		}
		List<BlobKey> blobKeys = blobs.get("locationImage");
		if (blobKeys == null || blobKeys.size() == 0 || id == null) {
			response.sendRedirect("/admin.jsp");
		}
		else {
			//check if the uploaded file is an image
			BlobKey key = blobKeys.get(0);
			try{
				ServingUrlOptions opts = ServingUrlOptions.Builder.withBlobKey(key);				
				imagesService.getServingUrl(opts);
				Location loc = ofy.get(Location.class, id);
				loc.imageBlobKey = key.getKeyString();
				ofy.put(loc);
				
			}
			catch(Exception ex){
				//error: it is not an image
				blobstoreService.delete(key);				
			}
			response.sendRedirect("/admin.jsp?selId="+id);
			
		}

	}
}
