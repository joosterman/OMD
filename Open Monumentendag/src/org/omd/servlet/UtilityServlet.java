package org.omd.servlet;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.omd.Utility;

import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class UtilityServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = -7232271415556123262L;
	private String uri = "http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=";
	private UserService userService = UserServiceFactory.getUserService();

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		Utility.setNoCacheJSON(response);

		String action = request.getParameter("action");
		if ("getLatLng".equals(action)) {
			String address = request.getParameter("address");
			if (address != null && address.length() > 0) {
				try {
					address = address.replace(" ", "%20");
					URL url = new URL(uri + address);
					BufferedReader reader = new BufferedReader(new InputStreamReader(url.openStream()));
					String line;
					StringBuilder pageBuilder = new StringBuilder();
					while ((line = reader.readLine()) != null) {
						pageBuilder.append(line);
					}
					reader.close();
					String output = pageBuilder.toString();
					response.getWriter().write(output);
				}
				catch (Exception ex) {
					ex.printStackTrace(response.getWriter());
				}
			}
		}
		else if("getLoginUrl".equals(action)){
			String returnURL = request.getParameter("returnUrl");
			String url = userService.createLoginURL(returnURL);
			response.getWriter().write(Utility.gson.toJson(url));
		}

	}
}
