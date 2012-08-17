package org.omd;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class CommentServlet extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		Objectify ofy = ObjectifyService.begin();
		Gson gson = new Gson();
		response.setContentType("application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");

		String action = request.getParameter("action");
		Long locationID, userID;
		String s_locationID = request.getParameter("locationID");
		String s_userID = request.getParameter("userID");
		String key = request.getParameter("key");
		
		try {
			locationID = Long.valueOf(s_locationID);
		}
		catch (NumberFormatException ex) {
			locationID = null;
		}
		try {
			userID = Long.valueOf(s_userID);
		}
		catch (NumberFormatException ex) {
			userID = null;
		}

		String comment = request.getParameter("comment");
		List<Comment> comments = null;
		String result = null;

		if ("get".equals(action)) {
			// vars: locationID, userID
			if (locationID != null && userID == null) {
				// return all for this location
				comments = ofy.query(Comment.class).filter("locationID", locationID).list();
			}
			else if (locationID != null && userID != null) {
				// return comment for this location and user
				comments = ofy.query(Comment.class).filter("userID", userID).filter("locationID", locationID).list();
			}
			else if (locationID == null && userID != null) {
				// return all for this user
				comments = ofy.query(Comment.class).filter("userID", userID).list();
			}
			else if (locationID == null && userID == null) {
				// return all
				comments = ofy.query(Comment.class).list();
			}
			result = gson.toJson(comments);
		}
		else if ("set".equals(action)) {
			// check if we have all the data
			if (locationID != null && userID != null && comment != null && comment.trim().length() > 0 && key!=null) {
				//check if the user exists (ID/key combination)
				User u = ofy.query(User.class).filter("Id", userID).filter("accessKey", key).get();
				if(u!=null){				
					//check if the user already posted a comment for this location, and delete that one.
					Comment c = ofy.query(Comment.class).filter("userID", userID).filter("locationID", locationID).get();
					Comment cnew = new Comment();
					if(c!=null){
						//overwrite
						cnew.id = c.id;
					}
					cnew.comment = comment;
					cnew.userID = userID;
					cnew.locationID = locationID;
					//store comment
					ofy.put(cnew);
				}
			}
			result = "done";
		}
		else if ("delete".equals(action)) {
			//user can only delete their own comments
			//check if we have all the data
			if (locationID != null && userID != null && key!=null) {
				//check if the user exists
				User u = ofy.query(User.class).filter("Id", userID).filter("accessKey", key).get();
				if(u!=null){
					//check if a comment exists
					Comment c = ofy.query(Comment.class).filter("userID", userID).filter("locationID", locationID).get();
					if(c!=null)
						ofy.delete(c);
				}
			}	
			result = "done";
		}
		else{
			result = "No action specified.";
		}
		response.getWriter().write(result);
	}
}
