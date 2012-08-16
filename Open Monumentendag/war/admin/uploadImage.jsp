<%@ page contentType="text/html; charset=UTF-8" %>
<%@page import="com.google.appengine.api.images.ServingUrlOptions"%>
<%@page import="java.lang.reflect.Modifier"%>
<%@ page import="java.lang.reflect.Field"%>
<%@ page import="com.googlecode.objectify.Objectify"%>
<%@ page import="com.googlecode.objectify.ObjectifyService"%>
<%@ page import="com.googlecode.objectify.Query"%>
<%@ page import="org.omd.Location"%>
<%@ page import="org.omd.LocationImage"%>
<%@ page import="org.omd.UserField"%>
<%@ page import="org.omd.UserField.FieldType"%>
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
	Query<Location> locations = null;

	String GetFieldValue(LocationImage loc, String fieldName) {
		if (loc == null)
			return "";
		else {
			String value = "";
			Object o = null;
			try {
				o = LocationImage.class.getDeclaredField(fieldName).get(loc);
				if (o != null) {
					value = o.toString();
				}
			}
			catch (Exception ex) {

			}
			return value;
		}
	}%>

<%
	String message = "";
	Location selLoc = null;
	LocationImage selImage = null;
	Query<LocationImage> locationImages = null;
	//Get the selected location and image id
	String idParam = request.getParameter("selId");
	Long selId = null;
	if (idParam != null && idParam.length() > 0) {
		selId = Long.valueOf(idParam);
	}
	idParam = request.getParameter("imageId");
	Long imageId = null;
	if (idParam != null && idParam.length() > 0) {
		imageId = Long.valueOf(idParam);
	}

	//check if we posted an action
	String action = request.getParameter("action");
	if("primary".equals(action)){
		if(selId!=null && imageId!=null){
			//get image and location image
			Location l = ofy.get(Location.class, selId);
			LocationImage li = ofy.get(LocationImage.class, imageId);
			if(l!=null && li!=null){
				//make all location images for this location not primary
				Query<LocationImage> lis = ofy.query(LocationImage.class).filter("locationID", l.id).filter("primary", true);
				for(LocationImage image:lis){
					image.primary = false;
					ofy.put(image);
				}
				//set the correct primary 						
				li.primary = true;
				ofy.put(li);
				//set the correct link to the location
				l.imageBlobKey = li.imageBlobKey;
				ServingUrlOptions opts = ServingUrlOptions.Builder.withBlobKey(li.imageBlobKey).imageSize(115);				
				l.thumbnailURL = imagesService.getServingUrl(opts);
				ofy.put(l);				
			}
		}
		response.sendRedirect("./uploadImage.jsp?selId="+selId+"&imageId="+imageId);
	}
	else if ("opslaan".equals(action)) {
		Class<LocationImage> cloc = LocationImage.class;
		LocationImage loc = ofy.get(LocationImage.class, Long.valueOf(request.getParameter("id")));
		Set<Map.Entry<String, String[]>> fields = request.getParameterMap().entrySet();
		for (Map.Entry<String, String[]> field : fields) {
			if (field.getKey().startsWith("field_")) {
				String f = field.getKey().replace("field_", "");
				String value = field.getValue()[0];
				//check if it is a String or boolean or double field
				String type = cloc.getDeclaredField(f).getType().getName();
				if (type.equals("java.lang.String")) {
					cloc.getDeclaredField(f).set(loc, value);
				}
				else if (type.equals("boolean")) {
					boolean b = Boolean.parseBoolean(value);
					cloc.getDeclaredField(f).set(loc, b);
				}
				else if (type.equals("double")) {
					double d = Double.parseDouble(value);
					cloc.getDeclaredField(f).set(loc, d);
				}
			}
		}
		ofy.put(loc);
		message = "Locatieafbeelding opgeslagen";
		response.sendRedirect("./uploadImage.jsp?selId=" + selId + "&imageId=" + imageId);
	}
	else if ("verwijder".equals(action)) {
		Long IdToDelete = Long.valueOf(request.getParameter("id"));
		ofy.delete(LocationImage.class, IdToDelete);
		message = "Afbeelding verwijderd";
		response.sendRedirect("./uploadImage.jsp?selId=" + selId);
	}
	else if ("nieuw".equals(action)) {
		String nieuw = "--- nieuw ---";
		Query<LocationImage> q = ofy.query(LocationImage.class).filter("filename", nieuw).filter("locationID", selId);
		Long newId;
		if (q.count() == 0) {
			LocationImage loc = new LocationImage(nieuw);
			loc.locationID = selId;
			loc.filename = nieuw;
			ofy.put(loc);
			newId = loc.id;
			message = "Nieuwe locatieafbeelding aangemaakt";
		}
		else {
			newId = q.get().id;
		}
		response.sendRedirect("./uploadImage.jsp?selId=" + selId + "&imageId=" + newId);
	}
	else {
		message = "";

		//get all locations
		locations = ofy.query(Location.class);

		//if there is no selected location, but we have locations, select the first one
		if (selId == null && locations != null && locations.count() > 0) {
			response.sendRedirect("./uploadImage.jsp?selId=" + locations.get().id);
		}

		//Get the selected location
		if (selId != null) {
			try {
				selLoc = ofy.get(Location.class, selId);
			}
			catch (Exception ex) {
				response.sendRedirect("./uploadImage.jsp");
				message = "Locatie met id " + selId + " bestaat niet (meer). U bent doorverwezen.";
			}
		}
		//get the selected image if a location was selected
		selImage = null;
		if (selLoc != null) {
			if (imageId != null) {
				selImage = ofy.get(LocationImage.class, imageId);
			}
		}

		//Get all images related to the selected location
		if (selLoc != null) {
			locationImages = ofy.query(LocationImage.class).filter("locationID", selLoc.id);
		}

		//if there is no selected locationImage, but we have images, select the first one
		if (imageId == null && locationImages != null && locationImages.count() > 0) {
			response.sendRedirect("./uploadImage.jsp?selId=" + selId + "&imageId=" + locationImages.get().id);
		}

		// an image was selected that does not belong to the location
		if (selLoc != null && selImage != null && !selImage.locationID.equals(selLoc.id)) {
			response.sendRedirect("./uploadImage.jsp?selId=" + selLoc.id);
		}
%>


<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="./stylesheets/admin.css" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript"
	src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript" src="./scripts/scripts.js"></script>
</head>

<body>
	<div class="selection">
		<form action="" method="get">
			Locatie <select name="selId" onchange="this.form.submit()">
				<%
					for (Location l : locations) {
				%>
				<option value="<%=l.id%>"
					<%=l.id.equals(selId) ? "selected=\"selected\"" : ""%>>
					<%=l.toString()%></option>
				<%
					}
				%>
			</select> Afbeelding <select name="imageId" onchange="this.form.submit()">
				<%
					for (LocationImage li : locationImages) {
				%>
				<option value="<%=li.id%>"
					<%=li.id.equals(imageId) ? "selected=\"selected\"" : ""%>>
					<%=li.toString()%></option>
				<%
					}
				%>
			</select>
		</form>
	</div>
	<div class="data">
	<h2>Data</h2>
		<form action="" method="POST">
			<table>
				<%
					Class<LocationImage> c = LocationImage.class;
						Field[] fields = c.getDeclaredFields();
						for (Field field : fields) {
							UserField uf = field.getAnnotation(UserField.class);
							if (uf != null) {
				%>
				<tr>
					<td><label for="<%=field.getName()%>"><%=field.getName()%></label></td>
					<td>
						<%
							if (uf.fieldType() == FieldType.textbox) {
						%> <input type="text" id="<%=field.getName()%>"
						name="<%="field_" + field.getName()%>"
						value="<%=GetFieldValue(selImage, field.getName())%>" /> <%
 	}
 				else if (uf.fieldType() == FieldType.radiobuttons) {
 %> yes <input type="radio" id="<%=field.getName()%>"
						name="<%="field_" + field.getName()%>" value="true"
						<%=GetFieldValue(selImage, field.getName()).equals("true") ? "checked=checked" : ""%> />
						no <input type="radio" id="<%=field.getName()%>"
						name="<%="field_" + field.getName()%>" value="false"
						<%=GetFieldValue(selImage, field.getName()).equals("false") ? "checked=checked" : ""%> />
						<%
							}
										else if (uf.fieldType() == FieldType.textarea) {
						%> <textarea id="<%=field.getName()%>"
							name="<%="field_" + field.getName()%>">
								<%=GetFieldValue(selImage, field.getName())%></textarea> <%
 	}
 %>
					</td>
				</tr>
				<%
					}
							else if (field.getAnnotation(javax.persistence.Id.class) != null) {
				%>
				<input type="hidden" name="id"
					value="<%=GetFieldValue(selImage, field.getName())%>" />
				<%
					}
						}
				%>
				<tr>
					<td colspan="2"><input type="submit" name="action"
						value="opslaan"
						<%=(selLoc == null || selImage == null) ? "disabled=disabled" : ""%> />
						<input type="submit" name="action" value="verwijder"
						<%=(selLoc == null || selImage == null) ? "disabled=disabled" : ""%> />
						<input type="submit" name="action" value="nieuw" /></td>
				</tr>
			</table>
		</form>
	</div>
	<div class="image">
	<h2>Image preview</h2>
	<em>Click top-left following by bottom-right to set crop</em><br />
		<%
			if (selImage != null) {
					if (selImage.imageBlobKey == null) {
		%>
		<p>Er is nog geen afbeelding geupload.</p>
		<%
			}
					else {
						ServingUrlOptions op = ServingUrlOptions.Builder.withBlobKey(selImage.imageBlobKey);
		%>
		<img class="measure" src="<%=imagesService.getServingUrl(op)%>" />
		<%
			}
		%>
		<form
			action="<%=blobstoreService.createUploadUrl("/admin/imageUpload?selId=" + selId + "&imageId=" + imageId)%>"
			method="post" enctype="multipart/form-data">
			<input type="file" name="locationImage"> <input type="submit"
				<%=(selLoc == null) ? "disabled=disabled" : ""%> value="upload">
		</form>
		<%
			}
		%>

	</div>
	<div class="images">
	<h2>Select primary image</h2>
		<%
			for (LocationImage li : locationImages) {
					if (li.imageBlobKey != null) {
						ServingUrlOptions op = ServingUrlOptions.Builder.withBlobKey(li.imageBlobKey).imageSize(80);
						String url = imagesService.getServingUrl(op);
		%>
		<div class="imagelist">
			<a
				href="./uploadImage.jsp?action=primary&selId=<%=selId%>&imageId=<%=li.id%>"><img
				src="<%=url%>" /></a> <br />
			<%
				if (li.primary) {
			%>
			Primary
			<%
				}
			%>

		</div>
		<%
			}
				}
		%>
	</div>

</body>
</html>
<%
	}
%>