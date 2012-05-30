package org.omp.test;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContextAttributeEvent;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobKey;
import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;

public class BlobDemo extends HttpServlet {
	private BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
		// test storing binary data
		 Map<String, List<BlobKey>> blobs = blobstoreService.getUploads(req);
		 List<BlobKey> blobKeys = blobs.get("myFile");

	        if (blobKeys == null || blobKeys.size()==0) {
	            resp.sendRedirect("/");
	        } else {
	            resp.sendRedirect("/serve?blob-key=" + blobKeys.get(0).getKeyString());
	        }
		 
		

	}

}
