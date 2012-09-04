package org.omd;

import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.blobstore.BlobstoreService;
import com.google.appengine.api.blobstore.BlobstoreServiceFactory;
import com.google.appengine.api.images.ImagesService;
import com.google.appengine.api.images.ImagesServiceFactory;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.google.gson.Gson;

public class Utility {

	public static final Gson gson = new Gson();
	public static final BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	public static final ImagesService imagesService = ImagesServiceFactory.getImagesService();
	public static final UserService userService = UserServiceFactory.getUserService();
	
	private Utility(){}
	
	public static Long parseLong(String s){
		try{
			Long l = new Long(s);
			return l;
		}
		catch(NumberFormatException ex){
			return null;
		}
	}

	public static Integer parseInt(String s){
		try{
			Integer i = new Integer(s);
			return i;
		}
		catch(NumberFormatException ex){
			return null;
		}
	}
	public static Double parseDouble(String s){
		try{
			Double d = new Double(s);
			return d;
		}
		catch(NumberFormatException ex){
			return null;
		}
	}

	
	public static void setNoCacheJSON(HttpServletResponse response){
		response.setContentType("application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		// Disable cache, also for IE
		// Set to expire far in the past.
		response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
		// Set standard HTTP/1.1 no-cache headers.
		response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
		// Set IE extended HTTP/1.1 no-cache headers (use addHeader).
		response.addHeader("Cache-Control", "post-check=0, pre-check=0");
		// Set standard HTTP/1.0 no-cache header.
		response.setHeader("Pragma", "no-cache");
	}
}
