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

	/**
	 * 
	 */
	private static final long serialVersionUID = 4040848189404871718L;
	private static Objectify ofy = ObjectifyService.begin();

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		Utility.setNoCacheJSON(response);

		User u = null;
		String action = request.getParameter("action");
		String key = request.getParameter("key");
		String userId = request.getParameter("userID");
		Long id = null;
		String output = null;
		try {
			id = Long.valueOf(userId);
		}
		catch (NumberFormatException ex) {
			// id stays null, no further action needed
		}
		// accesskey to ensure users only user there own user
		// Only non-key action is the create new user action

		// check key action combination
		if (key == null) {
			if (action == null || action.trim().equals("")) output = Utility.gson.toJson("No action specified.");
			else if ("new".equals(action)) {
				u = new User();
				ofy.put(u);
				output = Utility.gson.toJson(u);
			}
			else {
				output = Utility.gson.toJson("Action needs authorization key.");
			}
		}
		else {
			// check validity of key and check key-id combination
			u = ofy.query(User.class).filter("key", key).get();
			if (u == null || !u.id.equals(id)) {
				// return non-informative null
				output = Utility.gson.toJson(null);// "Key id combination not correct. For this key expected id: "+
																		// u.id+" but got: "+id);
			}
			else {
				if ("get".equals(action)) {
					output = Utility.gson.toJson(u);
				}
				else if ("update".equals(action)) {
					// email
					String email = request.getParameter("email");
					if (email != null) u.email = email;
					// location
					String lng = request.getParameter("lng");
					String lat = request.getParameter("lat");
					if (lng != null && lat != null) {
						try {
							float longitude = Float.valueOf(lng);
							float latitude = Float.valueOf(lat);
							GeoPt loc = new GeoPt(latitude, longitude);
							UserLocationHistory his = new UserLocationHistory();
							his.userID = id;
							his.location = loc;
							ofy.put(his);
							u.location = loc;
						}
						catch (NumberFormatException ex) {
							output = Utility.gson.toJson(false);
						}
					}
					if (output == null) {
						ofy.put(u);
						output = Utility.gson.toJson(true);
					}
				}
				else {
					output = Utility.gson.toJson(false);
				}
			}
		}
		// write JSON
		response.getWriter().write(output);
	}

}
