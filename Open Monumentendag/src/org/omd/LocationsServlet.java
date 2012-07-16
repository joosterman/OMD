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

public class LocationsServlet extends HttpServlet  {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		Objectify ofy = ObjectifyService.begin();
		List<Location> locs = new ArrayList<Location>();
		for(Location loc:ofy.query(Location.class)){
			locs.add(loc);		
		}
		Gson gson = new Gson();
		response.getWriter().write(gson.toJson(locs));
	}
}
