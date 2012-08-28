package org.omd.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.omd.Message;
import com.google.gson.Gson;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class MessageServlet extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6291865837941037511L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		//Initialize
		Objectify ofy = ObjectifyService.begin();
		Gson gson = new Gson();
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
		
		//actions
		String action = request.getParameter("action");
		List<Message> output = null;
		//return all messages
		output = ofy.query(Message.class).list();
		response.getWriter().write(gson.toJson(output));
	}

}
