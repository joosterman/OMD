<%@page import="org.omd.Location"%>
<%@page import="org.omd.Comment"%>
<%@page import="java.util.List"%>
<%@page import="com.googlecode.objectify.Objectify"%>
<%@page import="com.googlecode.objectify.ObjectifyService"%>
<%!//initialize
	Objectify ofy = ObjectifyService.begin();%>

<%
	String action = request.getParameter("action");
	String s_commentID = request.getParameter("commentID");
	Long commentID = null;
	try {
		commentID = Long.parseLong(s_commentID);
	}
	catch (Exception ex) {}
	if (commentID != null) {
		Comment c = ofy.find(Comment.class, commentID);
		if (c != null) {
			if ("goed".equals(action)) {
				c.adminApproved = true;
			}
			else if ("fout".equals(action)) {
				c.adminApproved = false;
			}
			ofy.put(c);
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
			<th>Commentaar</th>
			<th>Datum</th>
			<th>Flags</th>
			<th>Goedgekeurd/Afgekeurd</th>
		</tr>


		<%
			//show comments
			List<Comment> comments = ofy.query(Comment.class).filter("adminApproved", null).order("-flagged").list();
			List<Location> locations = ofy.query(Location.class).list();
			Location l;
			for (Comment c : comments) {
				//get location of this comment
				l = new Location();
				l.id = c.locationID;
				l = locations.get(locations.indexOf(l));
		%>
		<tr>
			<td><%=l.name%></td>
			<td><%=c.comment%></td>
			<td><%=c.date%></td>
			<td><%=c.flagged%></td>
			<td><form action="" method="GET">
					<input type="hidden" name="commentID" value="<%=c.id%>" />
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