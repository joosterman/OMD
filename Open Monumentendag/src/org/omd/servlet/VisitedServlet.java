package org.omd.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.omd.User;
import org.omd.Visit;

import com.google.gson.Gson;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class VisitedServlet extends HttpServlet {
	
	private Objectify ofy = ObjectifyService.begin();
	private Gson gson = new Gson();
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		// initialize
		response.setContentType("application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		// Disable cache, also for IE
		// Set to expire far in the past.
		response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
		// Set standard HTTP/1.1 no-cache headers.
		response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
		// Set IE extended HTTP/1.1 no-cache headers (use addHeader).
		response.addHeader("Cache-Control", "post-check=0, pre-check=0");
		// Set standard HTTP/1.0 no-cache header.
		response.setHeader("Pragma", "no-cache");
		
		String action = request.getParameter("action");
		String key = request.getParameter("key");
		String s_userID = request.getParameter("userID");
		String s_locationID = request.getParameter("locationID");
		String s_visited = request.getParameter("visited");
		Long userID = null;
		Long locationID = null;
		Boolean visited = null;
		try{
			userID = Long.parseLong(s_userID);
		}
		catch(Exception ex){}
		try{
			locationID = Long.parseLong(s_locationID);
		}
		catch(Exception ex){}
		try{
			visited = Boolean.parseBoolean(s_visited);
		}
		catch(Exception ex){}
		User user = null;
		if(userID!=null && key!=null){
			user = ofy.query(User.class).filter("id", userID).filter("key", key).get();
		}
		
		if("get".equals(action)){
			//for a get the location and user should be specified
			if(user==null || locationID==null){
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}
			else{
				//write out the visit object or null if not exists
				Visit v = ofy.query(Visit.class).filter("userID",userID).filter("locationID", locationID).get();
				response.getWriter().write(gson.toJson(v));
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
