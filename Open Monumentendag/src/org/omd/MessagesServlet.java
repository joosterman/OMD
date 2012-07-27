package org.omd;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.channel.ChannelMessage;
import com.google.appengine.api.channel.ChannelService;
import com.google.appengine.api.channel.ChannelServiceFactory;
import com.google.gson.Gson;

public class MessagesServlet extends HttpServlet {

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		Gson gson = new Gson();
		String userId = request.getParameter("id");
		if (userId != null && userId.trim().length() > 0) {
			// start of new channel for the user
			ChannelService channelService = ChannelServiceFactory.getChannelService();
			String token = channelService.createChannel(userId);
			response.getWriter().write(gson.toJson(token));
		}
		else {
			response.getWriter().write(gson.toJson(null));
		}
	}
}
