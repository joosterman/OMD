<%@page import="java.lang.reflect.Modifier"%>
<%@ page import="java.lang.reflect.Field"%>
<%@ page import="com.googlecode.objectify.Objectify"%>
<%@ page import="com.googlecode.objectify.ObjectifyService"%>
<%@ page import="com.googlecode.objectify.Query"%>
<%@ page import="org.omd.Location"%>
<%@ page import="org.omd.UserField"%>
<%@ page import="org.omd.UserField.FieldType"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page
	import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@ page import="com.google.appengine.api.images.ImagesService"%>
<%@ page import="com.google.appengine.api.images.ImagesServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobKey"%>

<%
	String locations = request.getParameter("locations");
	if (locations != null && locations.length() > 0) {
		BufferedReader reader = new BufferedReader(new StringReader(locations));
		String line = reader.readLine();
		
		//start Objectify and delete all current locations
		Objectify ofy = ObjectifyService.begin();
		ofy.delete(ofy.query(Location.class));
		
		//import all
		List<Location> locs = new ArrayList<Location>();
		Location loc;
		while (line != null && line.length() > 0) {
			//break up into pieces
			String[] fields = line.split(";",-1);
			//create and fill location object
			loc = new Location();
			loc.topLocation = fields[0].equals("ja");
			loc.number = fields[1];
			loc.name = fields[2];
			loc.street = fields[3];
			loc.openingHoursSaturday = fields[4];
			loc.openingHoursSunday = fields[5];
			loc.tourAvailable = fields[9].equals("ja");
			loc.wheelchairFriendly = fields[10].equals("ja");
			loc.info = fields[11];
			loc.description = fields[12];
			//add to save list
			locs.add(loc);
			//advance
			line = reader.readLine();
		}
		//store all locations
		ofy.put(locs);		
	}
%>


<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="./stylesheets/admin.css" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript"
	src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript"></script>
</head>
<body>
	<form action="" method="post">
		<textarea rows="20" cols="100" name="locations"></textarea>
		<br /> <input type="submit" value="Save" />
	</form>
</body>
</html>
