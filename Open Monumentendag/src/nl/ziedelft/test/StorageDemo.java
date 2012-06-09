package nl.ziedelft.test;

import java.io.IOException;
import java.util.Date;
import java.util.logging.Logger;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

@SuppressWarnings("serial")
public class StorageDemo extends HttpServlet {
	private static final Logger log = Logger.getLogger(StorageDemo.class.getName());
	private Objectify ofy;	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		// test logging
		log.warning("Warning created on " + new Date());

		// test storing of a Location object
		
		Location loc = new Location("Kerk", "Delft");
		ofy.put(loc);
		assert loc.id != null;

		// test retrieving information
		Location loc2 = ofy.get(Location.class, loc.id);
		assert loc.equals(loc2);
		int count = ofy.query(Location.class).filter("city", "Delft").count();
		resp.getWriter().write("Count = Delft: " + count);	

	}
	
	public void init(){
		ObjectifyService.register(Location.class);
		ofy = ObjectifyService.begin();
	}
	
	

}
