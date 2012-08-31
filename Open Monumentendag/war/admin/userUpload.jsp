<%@page import="org.omd.UserImage"%>
<%@page import="org.omd.Location"%>
<%@page import="org.omd.Comment"%>
<%@page import="java.util.List"%>
<%@page import="com.googlecode.objectify.Objectify"%>
<%@page import="com.googlecode.objectify.ObjectifyService"%>
<%!//initialize
	Objectify ofy = ObjectifyService.begin();%>
<%
	String action = request.getParameter("action");
	String s_userImageID = request.getParameter("userImageID");
	Long userImageID = null;
	try {
		userImageID = Long.parseLong(s_userImageID);
	}
	catch (Exception ex) {}
	if (userImageID != null) {
		UserImage ui = ofy.find(UserImage.class, userImageID);
		if (ui != null) {
			if ("goed".equals(action)) {
				ui.adminApproved = true;
			}
			else if ("fout".equals(action)) {
				ui.adminApproved = false;
			}
			ofy.put(ui);
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="./stylesheets/admin.css" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript" src="./scripts/scripts.js"></script>
</head>

<body>
	<jsp:include page="header.jsp"></jsp:include>
	<table border="1">
		<tr>
			<th>Locatie</th>
			<th>Afbeelding</th>
			<th>Datum</th>
			<th>Flags</th>
			<th>Goedgekeurd/Afgekeurd</th>
		</tr>


		<%
			//show comments
			List<UserImage> uis = ofy.query(UserImage.class).filter("adminApproved", null).order("-flagged").list();
			List<Location> locations = ofy.query(Location.class).list();
			Location l;
			for (UserImage ui : uis) {
				//get location of this comment
				l = new Location();
				l.id = ui.locationID;
				l = locations.get(locations.indexOf(l));
		%>
		<tr>
			<td><%=l.name%></td>
			<td><img style="width:200px" src="<%=ui.imageURL%>" /></td>
			<td><%=ui.date%></td>
			<td><%=ui.flagged%></td>
			<td><form action="" method="GET">
					<input type="hidden" name="userImageID" value="<%=ui.id%>" />
					<button type="submit" name="action" value="goed">Goed</button>
					<button type="submit" name="action" value="fout">Fout</button>
				</form></td>

		</tr>
		<%
			}
		%>

	</table>
</body>
</html>