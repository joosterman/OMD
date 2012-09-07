package org.omd.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.omd.User;
import org.omd.Utility;
import org.omd.View;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class ViewServlet extends HttpServlet {

	private static final long serialVersionUID = 7716429726537633280L;
	private Objectify ofy = ObjectifyService.begin();

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		Utility.setNoCacheJSON(response);

		String key = request.getParameter("key");
		Long userID = Utility.parseLong(request.getParameter("userID"));
		Long locationID = Utility.parseLong(request.getParameter("locationID"));

		// load user if able
		User user = null;
		if (userID != null && key != null) user = ofy.query(User.class).filter("id", userID).filter("key", key).get();
		
		if(user!=null && locationID!=null){
			View view = new View();
			view.userID = userID;
			view.locationID = locationID;
			ofy.put(view);		
		}

	}

}
