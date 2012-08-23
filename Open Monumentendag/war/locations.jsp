<%@ page import="com.googlecode.objectify.Objectify"%>
<%@ page import="com.googlecode.objectify.ObjectifyService"%>
<%@ page import="com.googlecode.objectify.Query"%>
<%@ page import ="org.omd.Location" %>
<%@ page import ="org.omd.LocationsSort" %>
<%@ page import ="java.util.List" %>
<%@ page import ="java.util.Collections" %>
<%@ page import ="java.util.Comparator" %>

<%!//get all locations
Objectify ofy = ObjectifyService.begin();
// sort locations based on toplocation and number
%>
<%
List<Location> locs = ofy.query(Location.class).list();
Collections.sort(locs, new Comparator<Location>() {
	public int compare(Location o1, Location o2) {
		return LocationsSort.compareLocations(o1, o2);
	}
});
%>

<div data-role="page" id="locations">
	<div data-theme="a" data-role="header" data-backbtn="true">
		<h1>Locaties</h1>
		<a href="/#home" data-icon="back">Back</a>
	</div>
	<div id="allLocations" data-role="content" class="ui-content">
		<ul class="locationsList ui-listview" data-role="listview" data-filter="true" data-filter-placeholder="Zoek een locatie...">
			<li data-role="list-divider" class="yellowBackground">Algemeen</li>
			<%	for (Location l : locs) { 	%>
				<% if(l.name.equals("Agnetapark")){ %>
					<li data-role="list-divider" class="greenBackground">Groen Top 10</li>
				<% } %>
				<% if(l.name.equals("Fundatie van Renswoude")){ %>
					<li data-role="list-divider" class="orangeBackground">Alleen zaterdag</li>
				<% } %>
				<% if(l.name.equals("Bierhuis De Klomp")){ %>
					<li data-role="list-divider" class="blueBackground">Zaterdag &amp; Zondag</li>
				<% } %>
				<% if(l.name.equals("St. Huybrechtstoren")){ %>
					<li data-role="list-divider" class="pinkBackground">Alleen Zondag</li>
				<% } %>
				
			
				<li id="location-<%=l.id%>">
					<a href="#detail?id=<%=l.id%>">
					<img src="http://jquerymobile.com/test/docs/lists/images/album-bb.jpg" alt="<%=l.name%>"/>
					<h3><font style="white-space:normal;"><%=l.name%></font></h3>
					<p><%=l.street%>,  <%=l.city%></p>
					<span class="ui-li-count" style="margin-top: -35px; visibility: hidden;">12.00 km</span>
					</a>
				</li>
			<% } %>
		</ul>
	</div>
</div>