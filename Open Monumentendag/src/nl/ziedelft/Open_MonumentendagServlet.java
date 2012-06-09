package nl.ziedelft;

import java.io.IOException;
import javax.servlet.http.*;
import org.json.JSONObject;

@SuppressWarnings("serial")
public class Open_MonumentendagServlet extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		String id = req.getParameter("id"); 
		//do stuff getting from DB
		JSONObject json = new JSONObject();
		json.put("name", "Locatie "+id);
		json.put("imageURL", "http://example.org/"+id+".png");
		json.put("description","dynamic description for "+json.getString("name"));
		
		//format output
		resp.setContentType("application/json");
		resp.getWriter().append(json.toString());
		
	}
}
