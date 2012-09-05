package org.omd.servlet;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.omd.Location;
import org.omd.LocationsSort;
import org.omd.Utility;

import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class LocationsServlet extends HttpServlet {
	
	private static final long serialVersionUID = -8884792081307234167L;
	private Objectify ofy = ObjectifyService.begin();

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		Utility.setNoCacheJSON(response);
		
		Long locationID = Utility.parseLong(request.getParameter("locationID"));

		if(locationID!=null){
			Location loc = ofy.find(Location.class,locationID);
			response.getWriter().write(Utility.gson.toJson(loc));
		}
		// return all
		else {
			List<Location> locs = ofy.query(Location.class).list();
			// sort locations based on toplocation and number
			Collections.sort(locs, new LocationsSort());
			response.getWriter().write(Utility.gson.toJson(locs));
		}
	}
}
