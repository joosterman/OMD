package org.omd.servlet;

import java.io.IOException;
import java.util.Collections;
import java.util.Comparator;
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
			response.getWriter().write(Utility.gson.toJson(loc));
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
			String result = Utility.gson.toJson(locs);
			response.getWriter().write(result);
		}
	}
}
