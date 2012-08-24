package org.omd;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class LocationImageServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7565297590913255950L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		// initialize
		Objectify ofy = ObjectifyService.begin();
		Gson gson = new Gson();
		// check for parameters
		String locID = request.getParameter("locationID");

		int id;
		try {
			id = Integer.parseInt(locID);
			List<LocationImage> images = ofy.query(LocationImage.class).filter("locationID", id).list();
			response.getWriter().write(gson.toJson(images));
		}
		catch (Exception ex) {
			response.getWriter().write(gson.toJson(null));
		}
	}
}