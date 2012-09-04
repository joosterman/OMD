package org.omd.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.omd.Like;
import org.omd.Like.LikeStatus;
import org.omd.User;
import org.omd.Utility;

import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class LikeServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = -8640329679546798112L;
	private static Objectify ofy = ObjectifyService.begin();

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		Utility.setNoCacheJSON(response);

		// Get params
		String action = request.getParameter("action");
		String s_status = request.getParameter("status");
		String s_userID = request.getParameter("userID");
		String s_locationID = request.getParameter("locationID");
		String key = request.getParameter("key");
		Long userID = null;
		Long locationID = null;
		User user = null;
		LikeStatus status = null;
		try {
			locationID = Long.parseLong(s_locationID);
			userID = Long.parseLong(s_userID);
			// get the user
			user = ofy.query(User.class).filter("id", userID).filter("key", key).get();
			
			status = LikeStatus.valueOf(s_status);
		}
		catch (Exception ex) {}

		// switch on action
		if ("set".equals(action)) {
			// check required params
			if (user == null || status == null || locationID == null) {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}
			else {
				// get existing like or create new like
				Like l = ofy.query(Like.class).filter("userID", userID).filter("locationID", locationID).get();
				if (l == null) {
					l = new Like();
					l.userID = userID;
					l.locationID = locationID;
				}
				// update status
				l.status = status;
				ofy.put(l);
				response.setStatus(HttpServletResponse.SC_OK);
			}
		}
		else if ("get".equals(action)) {
			// check required params
			if (locationID == null) {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			}
			else {
				List<Like> likes = ofy.query(Like.class).filter("locationID", locationID).list();
				int like = 0;
				int dislike = 0;
				LikeStatus userStatus = user == null ? null : LikeStatus.UNKNOWN;
				for (Like l : likes) {
					if (l.status == LikeStatus.LIKE) like++;
					else if (l.status == LikeStatus.DISLIKE) dislike++;

					if (user != null && user.id.equals(l.userID)) userStatus = l.status;
				}
				Likes ls = new Likes();
				ls.like = like;
				ls.dislike = dislike;
				ls.userStatus = userStatus;
				response.getWriter().write(Utility.gson.toJson(ls));
			}
		}

	}

	private class Likes {
		@SuppressWarnings("unused")
		int like;
		@SuppressWarnings("unused")
		int dislike;
		@SuppressWarnings("unused")
		LikeStatus userStatus;
	}
}
