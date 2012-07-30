<%@ page import="com.googlecode.objectify.Objectify"%>
<%@ page import="com.googlecode.objectify.ObjectifyService"%>
<%@ page import="com.googlecode.objectify.Query"%>
<%@ page import ="org.omd.Location" %>

<% //get all locations
	Objectify ofy = ObjectifyService.begin();
	Query<Location> locations = ofy.query(Location.class);

	//Get the selected location id
	String idParam = request.getParameter("id");
	Long selId = null;
	if (idParam != null && idParam.length() > 0) {
		try {
			selId = Long.valueOf(idParam);
		}
		catch (Exception ex) {
		}
	}
	
	//Get the selected locations
	Location loc = null;
	loc = new Location();
	loc.openingHoursSaturday = "";
	loc.openingHoursSunday = "";
	loc.info = "";
	
	if (selId != null) {
		try {
			loc = ofy.get(Location.class, selId);
		}catch (Exception ex) {
			//
		}
	}
%>
<<script type="text/javascript">
<!--
console.log(<%= idParam %>);
//-->
</script>
<div data-role="page" id="detail">
	<div data-theme="a" data-role="header" style="background: #d06516; color: #fff; border-color: #d06516;">
		<h3 class="locationName">OMD Delft</h3>
	</div>
	<div data-role="content">
		<h3 style="color: #d06516; margin: 0em;"><%= loc.name %></h3>
		<span style="color: #d06516;">&#47;</span>
		<p style="margin: 0em; color: #d06516;"><%= loc.street %></p>
		<span style="color: #d06516;">&#47;</span>
		
		<div style="width: 288px; height: 200px; position: relative; margin: auto; background-color: #fbfbfb; border: 1px solid #b8b8b8; overflow: hidden;">
			<div id="locationImageURL">
			</div>
			<div id="locationNumber"><%= loc.number %></div>
			<% if(loc.wheelchairFriendly){ %>
				<div id="locationWheelChair">
					<img src="img/wheelchair.png" width="40" height="40" alt="Rolstoel vriendelijk"/>
				</div>
			<% } %>
		</div>
		
		<div>
			<% if(!loc.openingHoursSaturday.equals("")){ %>
				<p><em>Zaterdag <%= loc.openingHoursSaturday %></em></p>
			<% } %>
			
			<% if(!loc.openingHoursSunday.equals("")){ %>
				<p><em>Zondag <%= loc.openingHoursSunday %></em></p>
			<% } %>
			
			<% if(!loc.info.equals("")){ %>
			<p>
				<strong style="color: #d06516;">Overige informatie:</strong>
				<br/>
				<%= loc.info %>
				<% if(loc.tourAvailable){ %>
					<br/>
					Op deze locatie worden rondleidingen gegeven.
				<% } %>				
			</p>
			<% } %>
			
			<p>
				<strong style="color: #d06516;">Omschrijving:</strong>
				<br/>
				<%= loc.description %>
			</p>
		</div>
		<ul id="Gallery" class="gallery">
		</ul>
	</div>
</div>