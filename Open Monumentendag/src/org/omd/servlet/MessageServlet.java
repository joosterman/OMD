package org.omd.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.omd.Message;
import org.omd.Utility;

import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class MessageServlet extends HttpServlet {
	
	private Objectify ofy = ObjectifyService.begin();
	private static final long serialVersionUID = 6291865837941037511L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		Utility.setNoCacheJSON(response);
		
		//actions
		String action = request.getParameter("action");
		List<Message> output = null;
		//return all messages
		output = ofy.query(Message.class).list();
		response.getWriter().write(Utility.gson.toJson(output));
	}

}
