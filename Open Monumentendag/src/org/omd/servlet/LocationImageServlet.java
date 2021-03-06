package org.omd.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.omd.LocationImage;
import org.omd.UserImage;
import org.omd.Utility;

import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class LocationImageServlet extends HttpServlet {

	private static final long serialVersionUID = 7565297590913255950L;
	private Objectify ofy = ObjectifyService.begin();

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		Utility.setNoCacheJSON(response);

		Long locationID = Utility.parseLong(request.getParameter("locationID"));
		if(locationID!=null){
			List<LocationImage> is = ofy.query(LocationImage.class).filter("locationID", locationID).list();
			List<UserImage> uis = ofy.query(UserImage.class).filter("locationID", locationID).list();
			AllImages ai = new AllImages();
			ai.userImages = uis;
			ai.systemImages = is;			
			response.getWriter().write(Utility.gson.toJson(ai));
		}
		else{
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