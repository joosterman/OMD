<%@ page import="com.googlecode.objectify.Objectify"%>
<%@ page import="com.googlecode.objectify.ObjectifyService"%>
<%@ page import="com.googlecode.objectify.Query"%>
<%@ page import ="org.omd.Location" %>
<%@ page import ="org.omd.LocationsSort" %>
<%@ page import ="java.util.List" %>
<%@ page import ="java.util.Collections" %>
<%@ page import ="java.util.Comparator" %>
<%@ page import = "com.google.appengine.api.images.ImagesServiceFactory" %>
<%@ page import = "com.google.appengine.api.images.ImagesService" %>
<%@ page import = "com.google.appengine.api.images.ServingUrlOptions" %>

<%!//get all locations
Objectify ofy = ObjectifyService.begin();
ImagesService imagesService = ImagesServiceFactory.getImagesService();
%>
<%
//sort locations based on toplocation and number
List<Location> locs = ofy.query(Location.class).list();
Collections.sort(locs, new LocationsSort());
%>

<div data-role="page" id="locations">
	<div data-theme="a" data-role="header" data-backbtn="true">
		<h1>Locaties</h1>
		<a href="/#home" data-icon="back">Back</a>
		<a class="ui-btn-right messagesLink" data-icon="custom-message" data-rel="dialog" data-role="button" data-transition = "slidedown" data-mini="true" href="#messages">0 Berichten</a>
	</div>
	<div id="allLocations" data-role="content" class="ui-content">
		<div id="flipswitch">
			<select name="flip-mini" id="flip-mini" data-role="slider" data-mini="true">
				<option value="off">Alles</option>
				<option value="on">Onbezocht</option>
			</select>
		</div>
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
					<% 
					String imageUrl;
					if(l.imageBlobKey==null){ 
						imageUrl="";
					}
					else{
						imageUrl = imagesService.getServingUrl(ServingUrlOptions.Builder.withBlobKey(l.imageBlobKey).imageSize(80).crop(true));
					}
					%>
					<img src="<%=imageUrl %>" alt="<%=l.name%>"/>
					<h3><font style="white-space:normal;"><%=l.name%></font></h3>
					<p><%=l.street%>,  <%=l.city%></p>
					<span class="ui-li-count" style="margin-top: -35px; visibility: hidden;">12.00 km</span>
					</a>
				</li>
			<% } %>
		</ul>
	</div>
</div>