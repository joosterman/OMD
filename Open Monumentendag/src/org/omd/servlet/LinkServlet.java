package org.omd.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.omd.Link;
import org.omd.Utility;
import com.googlecode.objectify.Objectify;
import com.googlecode.objectify.ObjectifyService;

public class LinkServlet extends HttpServlet {

	private Objectify ofy = ObjectifyService.begin();
	private static final long serialVersionUID = 3249795825540894921L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		Utility.setNoCacheJSON(response);
		
		Long locationID = Utility.parseLong(request.getParameter("locationID"));
		if(locationID!=null){
			List<Link> links = ofy.query(Link.class).filter("locationID",locationID).list();
			response.getWriter().write(Utility.gson.toJson(links));
		}
		else{
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		}
	}
}
