package org.omd;

import java.io.IOException;
import java.util.ArrayList;
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

	private boolean isNullOrEmpty(String s) {
		return s == null || s.trim().equals("");
	}

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
					// check special location (no number)
					boolean o1empty = isNullOrEmpty(o1.number);
					boolean o2empty = isNullOrEmpty(o2.number);
					if (o1empty && !o2empty)
						return -1;
					else if (!o1empty && o2empty)
						return 1;
					else if (o1empty && o2empty)
						//intentional reverse sort
						return o2.name.compareTo(o1.name);
					else {
						// check top location vs normal location
						if (o1.topLocation && !o2.topLocation)
							return -1;
						else if (!o1.topLocation && o2.topLocation)
							return 1;
						else {
							try {
								int nr1 = Integer.valueOf(o1.number);
								int nr2 = Integer.valueOf(o2.number);
								if(nr1<nr2)
									return -1;
								else if(nr1>nr2)
									return 1;
								else
									return 0;
							}
							catch (NumberFormatException ex) {
								return 0;
							}
						}
					}

				}

			});
			String result = gson.toJson(locs);
			response.getWriter().write(result);
		}
	}
}
