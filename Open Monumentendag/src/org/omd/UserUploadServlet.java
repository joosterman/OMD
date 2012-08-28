package org.omd;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.blobstore.UploadOptions;
import com.google.gson.Gson;

public class UserUploadServlet extends HttpServlet {
	private BlobstoreService blobstoreService = BlobstoreServiceFactory
			.getBlobstoreService();
	private UploadOptions uploadOptions = UploadOptions.Builder
			.withMaxUploadSizeBytesPerBlob(4*1024*1024);
	private Gson gson = new Gson();
	
	/**
	 * Handles the upload of an image by a user
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String successPath=request.getParameter("successPath");
		response.sendRedirect(successPath);
	}
	
	/**
	 * Returns a new fileUploadURL to the blobStorage
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String successPath = request.getParameter("successPath");
		if(successPath ==null){
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
		}
		else{
			String url = blobstoreService.createUploadUrl("/userUpload?successPath="+successPath, uploadOptions);
			response.getWriter().write(gson.toJson(url));
		}
		
	}
}
