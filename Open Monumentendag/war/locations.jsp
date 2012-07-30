<%@ page import="com.googlecode.objectify.Objectify"%>
<%@ page import="com.googlecode.objectify.ObjectifyService"%>
<%@ page import="com.googlecode.objectify.Query"%>
<%@ page import ="org.omd.Location" %>


<%!//get all locations
Objectify ofy = ObjectifyService.begin();
Query<Location> locations = ofy.query(Location.class);
%>

<div data-role="page" id="locations">
	<div data-theme="a" data-role="header" data-backbtn="true">
		<h1>Locaties</h1>
	</div>
	<div id="allLocations" data-role="content" class="ui-content">
		<ul class="locationsList ui-listview" data-role="listview" data-filter="true" data-filter-placeholder="Zoek een locatie...">
			<li data-role="list-divider">Algemeen</li>
			<%	for (Location l : locations) { 	%>
				<% if(l.name.equals("Agnetapark")){ %>
					<li data-role="list-divider">Groen Top 10</li>
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