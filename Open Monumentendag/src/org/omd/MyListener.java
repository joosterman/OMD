package org.omd;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import com.googlecode.objectify.ObjectifyService;

public class MyListener implements ServletContextListener {

	@Override
	public void contextDestroyed(ServletContextEvent arg0) {
		
	}

	@Override
	public void contextInitialized(ServletContextEvent arg0) {
		ObjectifyService.register(Location.class);
		ObjectifyService.register(LocationImage.class);
		ObjectifyService.register(User.class);
		ObjectifyService.register(UserLocationHistory.class);
		ObjectifyService.register(Comment.class);
		ObjectifyService.register(Message.class);
		ObjectifyService.register(UserImage.class);
		ObjectifyService.register(Like.class);
		ObjectifyService.register(Visit.class);
		
	}
}
