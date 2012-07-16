<%@page import="java.lang.reflect.Modifier"%>
<%@ page import="java.lang.reflect.Field"%>
<%@ page import="com.googlecode.objectify.Objectify"%>
<%@ page import="com.googlecode.objectify.ObjectifyService"%>
<%@ page import="com.googlecode.objectify.Query"%>
<%@ page import ="org.omd.Location" %>
<%@ page import ="org.omd.UserField" %>
<%@ page import ="org.omd.UserField.FieldType" %>
<%@ page import="java.util.*"%>
<%@ page
	import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@ page import="com.google.appengine.api.images.ImagesService"%>
<%@ page import="com.google.appengine.api.images.ImagesServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobKey"%>

<%!//declarations
	BlobstoreService blobstoreService = BlobstoreServiceFactory.getBlobstoreService();
	ImagesService imagesService = ImagesServiceFactory.getImagesService();
	Objectify ofy = ObjectifyService.begin();
	String message = "";
	Query<Location> locations = null;

	String GetFieldValue(Location loc, String fieldName) {
		if (loc == null)
			return "";
		else {
			String value = "";
			try {
				value = Location.class.getDeclaredField(fieldName).get(loc).toString();
			}
			catch (Exception ex) {
			}
			return value;
		}
	}%>

<%
	//Get the selected location id
	String idParam = request.getParameter("selId");
	Long selId = null;
	if (idParam != null && idParam.length() > 0) {
		try {
			selId = Long.valueOf(idParam);
		}
		catch (Exception ex) {
		}
	}

	//check if we posted an action
	String action = request.getParameter("action");
	if ("opslaan".equals(action)) {
		Class<Location> cloc = Location.class;
		Location loc = ofy.get(Location.class, Long.valueOf(request.getParameter("id")));
		Set<Map.Entry<String, String[]>> fields = request.getParameterMap().entrySet();
		for (Map.Entry<String, String[]> field : fields) {
			if (field.getKey().startsWith("field_")) {
				String f = field.getKey().replace("field_", "");
				String value = field.getValue()[0];
				//check if it is a String or boolean field
				String type = cloc.getDeclaredField(f).getType().getName();
				if(type.equals("java.lang.String"))
					cloc.getDeclaredField(f).set(loc, value);
				else if (type.equals("boolean")){
					boolean b = Boolean.parseBoolean(value);
					cloc.getDeclaredField(f).set(loc, b);
				}
			}
		}
		loc.lastChanged = new Date();
		ofy.put(loc);
		message = "Locatie opgeslagen";
	}
	else if ("verwijder".equals(action)) {
		Long IdToDelete = Long.valueOf(request.getParameter("id"));
		ofy.delete(Location.class, IdToDelete);
		message = "Locatie verwijderd";
	}
	else if ("nieuw".equals(action)) {
		String nieuw = "--- nieuw ---";
		Query<Location> q = ofy.query(Location.class).filter("name", nieuw);
		Long newId;
		if (q.count() == 0) {
			Location loc = new Location(nieuw);
			ofy.put(loc);
			newId = loc.id;
			message = "Nieuwe locatie aangemaakt";
		}
		else {
			newId = q.get().id;
		}
		response.sendRedirect("/admin.jsp?selId=" + newId);
		selId = newId;
	}
	else {
		message = "";
	}

	//get all locations
	locations = ofy.query(Location.class);

	//if there is no selected location, but we have locations, select the first one
	if (selId == null && locations.count() > 0) {
		response.sendRedirect("admin.jsp?selId=" + locations.get().id);
	}

	//Get the selected locations
	Location selLoc = null;
	if (selId != null) {
		try {
			selLoc = ofy.get(Location.class, selId);
		}
		catch (Exception ex) {
			response.sendRedirect("admin.jsp");
			message = "Locatie met id " + selId + " bestaat niet (meer). U bent doorverwezen.";
		}
	}
%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="./stylesheets/admin.css" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript" src="./scripts/tiny_mce/jquery.tinymce.js"></script>
<script type="text/javascript">
    $(window).load(function(){
    	$(".LatLng").click(function(){
    		var street = $("#street").val();
    		var streetnr = $("#streetNumber").val();
    		var city = $("#city").val();
    		var uri2 = "/admin?action=getLatLng&address="+street+"+"+streetnr+",+"+city;
    		$.getJSON(uri2, function(data){
    			$.each(data.results,function(){
    				$("#longitude").val(this.geometry.location.lng);
    				$("#latitude").val(this.geometry.location.lat);    				
    			});
    		});
    	});
    	$("textarea").tinymce({
            script_url: "./scripts/tiny_mce/tiny_mce.js",
            theme: "simple",
            width: "300",
            height: "200"
    	});
    });
    
</script>
</head>
<body>
	<p>
		<b><%=message%></b>
	</p>
	<div class="selection">
		<form action="" method="get">
			<select name="selId" onchange="this.form.submit()">
				<%
					for (Location l : locations) {
				%>
				<option value="<%=l.id%>"
					<%=l.id.equals(selId) ? "selected=\"selected\"" : ""%>>
					<%=l.toString()%></option>
				<%
					}
				%>
			</select>
		</form>
	</div>
	<div class="data">
		<input type="button" class="LatLng" value="Get LatLng from Google" />
		<form action="" method="post">
			<table>
				<%
					Class<Location> c = Location.class;
					Field[] fields = c.getDeclaredFields();
					for (Field field : fields) {
						UserField uf =field.getAnnotation(UserField.class); 
						if (uf !=null) {
				%>
				<tr>
					<td><label for="<%=field.getName()%>"><%=field.getName()%></label></td>
					<td>
						<%
							
							if (uf.fieldType() == FieldType.textbox) {
						%> 
								<input type="text" id="<%=field.getName()%>"
								name="<%="field_" + field.getName()%>"
								value="<%=GetFieldValue(selLoc, field.getName())%>" /> 
						<%
 							}
 							else if (uf.fieldType() == FieldType.radiobuttons) {
 						%> 
 								yes
 								<input type="radio" id="<%=field.getName()%>"
								name="<%="field_" + field.getName()%>"
								value="true" <%= GetFieldValue(selLoc, field.getName()).equals("true")?"checked=checked":"" %> />
								no
								<input type="radio" id="<%=field.getName()%>"
								name="<%="field_" + field.getName()%>"
								value="false" <%= GetFieldValue(selLoc, field.getName()).equals("false")?"checked=checked":"" %> />						
						 <%
 							}
 							else if (uf.fieldType() == FieldType.textarea){
						 %>
						 		<textarea id="<%=field.getName()%>"
								name="<%="field_" + field.getName()%>">
								<%=GetFieldValue(selLoc, field.getName())%></textarea>
						 <%
 							}
						 %>
					</td>
				</tr>
				<%
					}
						else if (field.getAnnotation(javax.persistence.Id.class)!=null) {
				%>
				<input type="hidden" name="id"
					value="<%=GetFieldValue(selLoc, field.getName())%>" />
				<%
						}
					}
				%>
				<tr>
					<td colspan="2"><input type="submit" name="action"
						value="opslaan" <%=selLoc == null ? "disabled=disabled" : ""%> />
						<input type="submit" name="action" value="verwijder"
						<%=selLoc == null ? "disabled=disabled" : ""%> /> <input
						type="submit" name="action" value="nieuw" /></td>
				</tr>
			</table>
		</form>
	</div>
	<div class="image">
		<%
			if (selLoc != null) {
				if (selLoc.imageBlobKey == null || selLoc.imageBlobKey.length() == 0) {
		%>
		<p>Er is nog geen afbeelding geupload</p>
		<%
			}
				else {
		%>
		<img
			src="<%=imagesService.getServingUrl(new BlobKey(selLoc.imageBlobKey), 400, false)%>" />
		<%
			}
		%>
		<form
			action="<%=blobstoreService.createUploadUrl("/imageUpload?id=" + selId)%>"
			method="post" enctype="multipart/form-data">
			<input type="file" name="locationImage"> <input type="submit"
				value="upload">
		</form>
	</div>
	<%
		}
	%>
</body>
</html>