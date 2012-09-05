package org.omd.servlet;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.omd.User;
import org.omd.UserLocationHistory;
import org.omd.Utility;

import com.google.appengine.api.datastore.GeoPt;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class UserServlet extends HttpServlet {

	private static final long serialVersionUID = 4040848189404871718L;
	private Objectify ofy = ObjectifyService.begin();

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		Utility.setNoCacheJSON(response);

		Long userID = Utility.parseLong(request.getParameter("userID"));
		String key = request.getParameter("key");
		String action = request.getParameter("action");

		// load user if able
		User user = null;
		if (userID != null && key != null)
			user = ofy.query(User.class).filter("id", userID).filter("key", key).get();

		if ("new".equals(action)) {
			User u = new User();
			ofy.put(u);
			response.getWriter().write(Utility.gson.toJson(u));
		}
		else if ("get".equals(action)) {
			if (user != null)
				response.getWriter().write(Utility.gson.toJson(user));
			else
				response.getWriter().write(Utility.gson.toJson(null));
		}
		else if ("update".equals(action)) {
			if (user != null) {
				//email (never clear the value
				String email = request.getParameter("email");
				if (email != null && !email.equals(""))
					user.email = email;
				// location
				Float lng = Utility.parseFloat(request.getParameter("lng"));
				Float lat = Utility.parseFloat(request.getParameter("lat"));
				if (lng != null && lat != null) {
					GeoPt loc = new GeoPt(lat, lng);
					UserLocationHistory his = new UserLocationHistory();
					his.userID = user.id;
					his.location = loc;
					user.location = loc;
					ofy.put(his);					
				}
				ofy.put(user);
			}
			else {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}
		}
	}
}
