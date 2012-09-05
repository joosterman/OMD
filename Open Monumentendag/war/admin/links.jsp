<%@page import="org.omd.Location"%>
<%@page import="org.omd.Utility"%>
<%@page import="org.omd.Link"%>
<%@page import="java.util.List"%>
<%@page import="com.googlecode.objectify.Objectify"%>
<%@page import="com.googlecode.objectify.ObjectifyService"%>
<%!//initialize
	Objectify ofy = ObjectifyService.begin();
	//get all locations
	List<Location> locations = ofy.query(Location.class).list();%>

<%
	Long linkID = Utility.parseLong(request.getParameter("linkID"));
	Long locationID = Utility.parseLong(request.getParameter("locationID"));
	Link link = null;
	Location location = null;
	List<Link> links = null;
	
	//get selected link if able
	if (linkID != null) {
		link = ofy.find(Link.class, linkID);
		//Reset link if it does not match location
		if(!locationID.equals(link.locationID))
			link = null;
	}
	
	
	
	//get selected location
	if (locationID != null) {
		location = ofy.find(Location.class, locationID);
	}

	//check action
	String action = request.getParameter("action");
	if ("nieuw".equals(action)) {
		if (locationID != null) {
			Link newLink = new Link();
			newLink.locationID = locationID;
			newLink.linkText = "nieuw";
			ofy.put(newLink);
			response.sendRedirect("links.jsp?locationID=" + locationID + "&linkID=" + newLink.id);
		}
	}
	else if ("opslaan".equals(action)) {
		String url = request.getParameter("linkURL");
		String text = request.getParameter("linkText");
		String description = request.getParameter("linkDescription");
		if(linkID!=null && locationID !=null){
			Link updatedLink = new Link();
			updatedLink.id = linkID;
			updatedLink.locationID = locationID;
			updatedLink.linkURL = url;
			updatedLink.linkText = text;
			updatedLink.linkDescription = description;
			ofy.put(updatedLink);
			//use new info
			link = updatedLink;
		}
	}
	else if ("verwijder".equals(action)) {
		if(linkID!=null){
			ofy.delete(Link.class, linkID);
			response.sendRedirect("links.jsp?locationID=" + locationID);
		}
	}
	
	//get all links for this location
	if (locationID != null) {
		links = ofy.query(Link.class).filter("locationID", locationID).list();
	}
	
	//if there is no selected location, but we have locations, select the first one
	if (locationID == null && locations.size() > 0) {
		response.sendRedirect("links.jsp?locationID=" + locations.get(0).id);
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
	<form>
		<select name="locationID" onchange="this.form.submit()">
			<%
				if (locations != null) {
					for (Location loc : locations) {
			%>
			<option value="<%=loc.id%>" <%=loc.id.equals(locationID) ? "selected=\"selected\"" : ""%>><%=loc.name%></option>
			<%
				}
				}
			%>
		</select> <select name="linkID" onchange="this.form.submit()">
		<option>---Selecteer link---</option>
			<%
				if (links != null) {
					for (Link l : links) {
			%>
			<option value="<%=l.id%>" <%=l.id.equals(linkID) ? "selected=\"selected\"" : ""%>><%=l.linkText%></option>
			<%
				}
				}
			%>
		</select> <br />
		<table >
			<tr>
				<td><label for="linkURL">Link URL</label></td>
				<td class="inputs"><input type="text" name="linkURL" id="linkURL" value="<%=link!=null&&link.linkURL!=null?link.linkURL:"" %>" /></td>
			</tr>
			<tr>
				<td><label for="linkText">Link text</label></td>
				<td class="inputs"><input type="text" name="linkText" id="linkText" value="<%=link!=null&&link.linkText!=null?link.linkText:"" %>" /></td>
			</tr>
			<tr>
				<td><label for="linkDescription">Link description</label></td>
				<td class="inputs"><input type="text" name="linkDescription" id="linkDescription" value="<%=link!=null&&link.linkDescription!=null?link.linkDescription:"" %>" /></td>
			</tr>
			<tr>
				<td colspan="2"><input type="submit" name="action" value="opslaan" <%=link == null ? "disabled=disabled" : ""%> /> <input
					type="submit" name="action" value="verwijder" <%=link == null ? "disabled=disabled" : ""%> /> <input type="submit" name="action"
					value="nieuw" /></td>
				</td>
		</table>
	</form>
</body>
</html>