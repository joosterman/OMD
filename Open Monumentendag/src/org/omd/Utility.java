package org.omd;

import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

public class Utility {

	public static final Gson gson = new Gson();
	
	private Utility(){}
	
	public static Boolean parseBoolean(String s){
		try{
			Boolean b= new Boolean(s);
			return b;
		}
		catch(Exception ex){
			return null;
		}
		
	}
	public static Float parseFloat(String s){
		try{
			Float f= new Float(s);
			return f;
		}
		catch(Exception ex){
			return null;
		}
	}
	
	public static Long parseLong(String s){
		try{
			Long l = new Long(s);
			return l;
		}
		catch(Exception ex){
			return null;
		}
	}

	public static Integer parseInt(String s){
		try{
			Integer i = new Integer(s);
			return i;
		}
		catch(Exception ex){
			return null;
		}
	}
	public static Double parseDouble(String s){
		try{
			Double d = new Double(s);
			return d;
		}
		catch(Exception ex){
			return null;
		}
	}

	
	public static void setNoCacheJSON(HttpServletResponse response){
		//set to return JSON
		response.setContentType("application/json; charset=UTF-8");
		response.setCharacterEncoding("UTF-8");
		// Disable cache, also for IE
		// Set to expire far in the past.
		response.setHeader("Expires", "Sat, 6 May 1995 12:00:00 GMT");
		// Set standard HTTP/1.1 no-cache headers.
		response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
		// Set IE extended HTTP/1.1 no-cache headers (use addHeader).
		response.addHeader("Cache-Control", "post-check=0, pre-check=0");
		// Set standard HTTP/1.0 no-cache header.
		response.setHeader("Pragma", "no-cache");
	}
}
