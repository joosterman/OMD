package org.omd.servlet;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.omd.LocationImage;

import com.google.appengine.api.blobstore.BlobInfo;
import com.google.appengine.api.blobstore.BlobInfoFactory;
import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;
import com.google.appengine.api.images.ServingUrlOptions;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class ImageUploadServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4094732054437532029L;
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	private ImagesService imagesService = ImagesServiceFactory.getImagesService();
	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		Objectify ofy = ObjectifyService.begin();
		Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(request);
		Long locationId = null;
		Long imageId = null;
		try {
			locationId = Long.valueOf(request.getParameter("selId"));
			imageId = Long.valueOf(request.getParameter("imageId"));
		}
		catch (Exception ex) {
		}
		List<BlobKey> blobKeys = blobs.get("locationImage");
		if (blobKeys == null || blobKeys.size() == 0 || locationId == null || imageId==null) {
			response.sendRedirect("/uploadImage.jsp");
		}
		else {
			//check if the uploaded file is an image
			BlobKey key = blobKeys.get(0);
			try{
				ServingUrlOptions opts = ServingUrlOptions.Builder.withBlobKey(key);				
				imagesService.getServingUrl(opts);
				BlobInfoFactory fac = new BlobInfoFactory();
				BlobInfo info = fac.loadBlobInfo(key);
				LocationImage li = ofy.get(LocationImage.class, imageId);
				li.filename = info.getFilename();
				li.imageBlobKey = key;
				
				li.imageURL = imagesService.getServingUrl(opts);
				ofy.put(li);
				
			}
			catch(Exception ex){
				//error: it is not an image
				blobstoreService.delete(key);				
			}
			response.sendRedirect("/admin/uploadImage.jsp?selId="+locationId+"&imageId="+imageId);
			
		}

	}
}
