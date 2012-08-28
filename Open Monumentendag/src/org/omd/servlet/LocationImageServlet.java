package org.omd.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.omd.LocationImage;
import org.omd.UserImage;
import com.google.gson.Gson;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class LocationImageServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7565297590913255950L;
	private Objectify ofy = ObjectifyService.begin();
	private Gson gson = new Gson();

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		// initialize
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

		// check for parameters
		String locID = request.getParameter("locationID");

		int id;
		try {
			id = Integer.parseInt(locID);
			final List<LocationImage> is = ofy.query(LocationImage.class).filter("locationID", id).list();
			final List<UserImage> uis = ofy.query(UserImage.class).filter("locationID", id).list();
			AllImages ai = new AllImages();
			ai.userImages = uis;
			ai.systemImages = is;			
			response.getWriter().write(gson.toJson(ai));
		}
		catch (Exception ex) {
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
	}
	private class AllImages{
		@SuppressWarnings("unused")
		public List<LocationImage> systemImages;
		@SuppressWarnings("unused")
		public List<UserImage> userImages;
	}
	
}