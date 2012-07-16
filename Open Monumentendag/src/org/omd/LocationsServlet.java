package org.omd;

import java.io.IOException;
import java.util.ArrayList;
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
		//initialize
		Objectify ofy = ObjectifyService.begin();
		Gson gson = new Gson();
		//check for parameters
		String locID = request.getParameter("locationID");
		//return one
		if (locID != null && locID.length() > 0) {
			int id;
			try{
				id = Integer.parseInt(locID);
			}
			catch(Exception ex){
				id = -1;
			}
			Location loc = ofy.query(Location.class).filter("id", id).get();
			response.getWriter().write(gson.toJson(loc));
		}
		//return all
		else {
			List<Location> locs = new ArrayList<Location>();
			for (Location loc : ofy.query(Location.class)) {
				locs.add(loc);
			}
			response.getWriter().write(gson.toJson(locs));
		}
	}
}
