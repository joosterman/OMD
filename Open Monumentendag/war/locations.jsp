<%@ page import="com.googlecode.objectify.Objectify"%>
<%@ page import="com.googlecode.objectify.ObjectifyService"%>
<%@ page import="com.googlecode.objectify.Query"%>
<%@ page import ="org.omd.Location" %>
<%@ page import ="java.util.List" %>
<%@ page import ="java.util.Collections" %>
<%@ page import ="java.util.Comparator" %>


<%!//get all locations
Objectify ofy = ObjectifyService.begin();

List<Location> locs = ofy.query(Location.class).list();
// sort locations based on toplocation and number
%>
<%
Collections.sort(locs, new Comparator<Location>() {
	public int compare(Location o1, Location o2) {
		// check special location (no number)
		boolean o1empty = o1.number == null || o1.number.trim().equals("");
		boolean o2empty = o2.number == null || o2.number.trim().equals("");
		if (o1empty && !o2empty)
			return -1;
		else if (!o1empty && o2empty)
			return 1;
		else if (o1empty && o2empty)
			//intentional reverse sort
			return o2.name.compareTo(o1.name);
		else {
			// check top location vs normal location
			if (o1.topLocation && !o2.topLocation)
				return -1;
			else if (!o1.topLocation && o2.topLocation)
				return 1;
			else {
				try {
					int nr1 = Integer.valueOf(o1.number);
					int nr2 = Integer.valueOf(o2.number);
					if(nr1<nr2)
						return -1;
					else if(nr1>nr2)
						return 1;
					else
						return 0;
				}
				catch (NumberFormatException ex) {
					return 0;
				}
			}
		}

	}

});
%>

<div data-role="page" id="locations">
	<div data-theme="a" data-role="header" data-backbtn="true">
		<h1>Locaties</h1>
	</div>
	<div id="allLocations" data-role="content" class="ui-content">
		<ul class="locationsList ui-listview" data-role="listview" data-filter="true" data-filter-placeholder="Zoek een locatie...">
			<li data-role="list-divider">Algemeen</li>
			<%	for (Location l : locs) { 	%>
				<% if(l.name.equals("Agnetapark")){ %>
					<li data-role="list-divider">Groen Top 10</li>
				<% } %>
				<% if(l.name.equals("Fundatie van Renswoude")){ %>
					<li data-role="list-divider">ZA - Alleen zaterdag</li>
				<% } %>
				<% if(l.name.equals("Bierhuis De Klomp")){ %>
					<li data-role="list-divider">ZA/ZO - Zaterdag &amp; Zondag</li>
				<% } %>
				<% if(l.name.equals("St. Huybrechtstoren")){ %>
					<li data-role="list-divider">ZO - Alleen Zondag</li>
				<% } %>
				
			
				<li>
					<a href="#detail?id=<%=l.id%>">
					<img src="http://jquerymobile.com/test/docs/lists/images/album-bb.jpg" alt="<%=l.name%>"/>
					<h3><%=l.name%></h3>
					<p><%=l.street%>,  <%=l.city%></p>
					<span class="ui-li-count">12</span>
					</a>
				</li>
			<% } %>
		</ul>
	</div>
</div>