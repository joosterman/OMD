package org.omd.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.omd.Comment;
import org.omd.User;
import org.omd.Utility;

import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.Query;

public class CommentServlet extends HttpServlet {
	private static final long serialVersionUID = 8828056617136222338L;
	private Objectify ofy = ObjectifyService.begin();

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		// initialize response object
		Utility.setNoCacheJSON(response);

		// load parameters
		String action = request.getParameter("action");
		Long locationID = Utility.parseLong(request.getParameter("locationID"));
		Long userID = Utility.parseLong(request.getParameter("userID"));
		String key = request.getParameter("key");
		String comment = request.getParameter("comment");
		Long commentID = Utility.parseLong(request.getParameter("commentID"));

		// load user if able
		User user = null;
		if (userID != null && key != null)
			user = ofy.query(User.class).filter("id", userID).filter("key", key).get();

		// load user location comment if able
		Comment c = null;
		if (user != null && locationID != null)
			c = ofy.query(Comment.class).filter("userID", userID).filter("locationID", locationID).get();
		else if (commentID != null)
			c = ofy.find(Comment.class, commentID);

		// switch per action
		if ("get".equals(action)) {
			Query<Comment> comments = null;
			if (locationID != null && userID == null) {
				// return all for this location
				comments = ofy.query(Comment.class).filter("locationID", locationID);
			}
			else if (locationID != null && userID != null) {
				// return comment for this location and user
				comments = ofy.query(Comment.class).filter("userID", userID).filter("locationID", locationID);
			}
			else if (locationID == null && userID != null) {
				// return all for this user
				comments = ofy.query(Comment.class).filter("userID", userID);
			}
			else if (locationID == null && userID == null) {
				// return all
				comments = ofy.query(Comment.class);
			}
			response.getWriter().write(Utility.gson.toJson(comments.list()));
		}
		else if ("set".equals(action)) {
			// check if we have all the data
			if (user != null && locationID != null && comment != null && comment.trim().length() > 0) {
				// check if the user already posted a comment for this
				// location, and overwrite that one
				Long id = null;
				if (c != null) {
					id = c.id;
				}
				// overwrite
				c = new Comment();
				c.id = id;
				c.comment = comment;
				c.userID = userID;
				c.locationID = locationID;
				// store comment
				ofy.put(c);
				// send OK
				response.setStatus(HttpServletResponse.SC_OK);
			}
			else {
				// wrong params
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}
		}
		else if ("delete".equals(action)) {
			// user can only delete their own comments
			// check if we have all the data
			if (user != null && locationID != null) {
				// either it does not exist or we delete it
				if (c != null) {
					ofy.delete(c);
				}
				// send OK
				response.setStatus(HttpServletResponse.SC_OK);
			}
			else {
				// wrong params
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}

		}
		else if ("flag".equals(action)) {
			if (commentID != null && c != null) {
				c.flagged++;
				ofy.put(c);
				// send OK
				response.setStatus(HttpServletResponse.SC_OK);
			}
			else {
				// wrong params
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}
		}
	}
}
