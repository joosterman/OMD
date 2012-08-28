package org.omd.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.omd.Comment;
import org.omd.User;
import com.google.gson.Gson;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class CommentServlet extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8828056617136222338L;
	final String success = "success";
	private Objectify ofy = ObjectifyService.begin();
	private Gson gson = new Gson();

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		// initialize		
		response.setContentType("application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		//Disable cache, also for IE
		// Set to expire far in the past.
		response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
		// Set standard HTTP/1.1 no-cache headers.
		response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
		// Set IE extended HTTP/1.1 no-cache headers (use addHeader).
		response.addHeader("Cache-Control", "post-check=0, pre-check=0");
		// Set standard HTTP/1.0 no-cache header.
		response.setHeader("Pragma", "no-cache");

		// load parameters
		String action = request.getParameter("action");
		Long locationID, userID;
		String s_locationID = request.getParameter("locationID");
		String s_userID = request.getParameter("userID");
		String key = request.getParameter("key");
		String comment = request.getParameter("comment");
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

		// result object
		Object result = null;

		// switch per action
		if ("get".equals(action)) {
			List<Comment> comments = null;
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
			result = comments;
		}
		else if ("set".equals(action)) {
			// check if we have all the data
			if (locationID != null && userID != null && comment != null && comment.trim().length() > 0 && key != null) {
				// check if the user exists (ID/key combination)
				User u = ofy.query(User.class).filter("id", userID).filter("key", key).get();
				if (u != null) {
					// check if the user already posted a comment for this
					// location, and overwrite that one
					Comment c = ofy.query(Comment.class).filter("userID", userID).filter("locationID", locationID).get();
					Comment cnew = new Comment();
					if (c != null) {
						// overwrite
						cnew.id = c.id;
					}
					cnew.comment = comment;
					cnew.userID = userID;
					cnew.locationID = locationID;
					// store comment
					ofy.put(cnew);
					result = success;
				}
			}
		}
		else if ("delete".equals(action)) {
			// user can only delete their own comments
			// check if we have all the data
			if (locationID != null && userID != null && key != null) {
				// check if the user exists
				User u = ofy.query(User.class).filter("id", userID).filter("key", key).get();
				if (u != null) {
					// check if a comment exists
					Comment c = ofy.query(Comment.class).filter("userID", userID).filter("locationID", locationID).get();
					if (c != null) {
						ofy.delete(c);
						result = success;
					}
				}
			}
		}
		response.getWriter().write(gson.toJson(result));
	}
}