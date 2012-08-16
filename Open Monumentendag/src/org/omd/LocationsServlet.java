package org.omd;

import java.io.IOException;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class LocationsServlet extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		response.setContentType("application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");		
		// initialize
		Objectify ofy = ObjectifyService.begin();
		Gson gson = new Gson();
		// check for parameters
		String locID = request.getParameter("locationID");
		// return one
		if (locID != null && locID.length() > 0) {
			int id;
			try {
				id = Integer.parseInt(locID);
			}
			catch (Exception ex) {
				id = -1;
			}
			Location loc = ofy.query(Location.class).filter("id", id).get();
			response.getWriter().write(gson.toJson(loc));
		}
		// return all
		else {
			// top, nummer, test nummer
			List<Location> locs = ofy.query(Location.class).list();
			// sort locations based on toplocation and number
			Collections.sort(locs, new Comparator<Location>() {
				@Override
				public int compare(Location o1, Location o2) {
					return LocationsSort.compareLocations(o1, o2);
				}

			});
			String result = gson.toJson(locs);
			response.getWriter().write(result);
		}
	}
}
