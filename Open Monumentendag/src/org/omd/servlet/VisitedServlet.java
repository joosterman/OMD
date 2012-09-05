package org.omd.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.omd.User;
import org.omd.Utility;
import org.omd.Visit;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class VisitedServlet extends HttpServlet {
	private static final long serialVersionUID = 3425836810054159996L;
	private Objectify ofy = ObjectifyService.begin();
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		Utility.setNoCacheJSON(response);
		
		String action = request.getParameter("action");
		String key = request.getParameter("key");
		Long userID = Utility.parseLong(request.getParameter("userID"));
		Long locationID = Utility.parseLong(request.getParameter("locationID"));
		Boolean visited = Utility.parseBoolean(request.getParameter("visited"));
		
		// load user if able
		User user = null;
		if (userID != null && key != null)
			user = ofy.query(User.class).filter("id", userID).filter("key", key).get();

	
		if("get".equals(action)){
			//for a get the location and user should be specified
			if(user==null && locationID==null){
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}
			else if(user!=null && locationID==null){
				List<Visit> visits = ofy.query(Visit.class).filter("userID", userID).list();
				response.getWriter().write(Utility.gson.toJson(visits));
			}
			else{
				//write out the visit object or null if not exists
				Visit v = ofy.query(Visit.class).filter("userID",userID).filter("locationID", locationID).get();
				response.getWriter().write(Utility.gson.toJson(v));
			}
		}
		else if("set".equals(action)){
			//for a set the location, user and visited (true/false) should be specified 
			if(user==null || locationID==null || visited==null){
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}
			else{
				Visit v = ofy.query(Visit.class).filter("userID",userID).filter("locationID", locationID).get();
				if(v==null){
					v = new Visit();
					v.locationID = locationID;
					v.userID = userID;
				}
				v.visited = visited;
				ofy.put(v);
				response.setStatus(HttpServletResponse.SC_OK);
			}
		}
		else{
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
		
	}

}
