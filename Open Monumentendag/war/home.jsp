<%@page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@page import="com.google.appengine.api.blobstore.BlobKey"%>
<%@page import="com.google.appengine.api.images.ServingUrlOptions"%>
<%@ page import="com.google.appengine.api.images.ImagesServiceFactory"%>
<%@ page import="com.google.appengine.api.images.ImagesService"%>
<%!ImagesService imageService = ImagesServiceFactory.getImagesService();
	BlobKey omdKey = new BlobKey(
			"AMIfv95pccUZQwNoI4llTrAg0Qv6hZmUFe6L66L8bKyyi7n5ce-sgewexj_ttBwTpISisQNzK9iuvPxH1vPp5VryUtd8MrKH5hF_v643EIZu6v-UdilIg0pulwbet7WRh15aYI0exkuHC2o3nzmH3yTK3QDVX7QP5NAyST_LalV0-IFL0mXL_vg");
	ServingUrlOptions omdOpts = ServingUrlOptions.Builder.withBlobKey(omdKey).imageSize(300);
	String omdUrl = null;

	void setUrls() {
		if (omdUrl == null) {
			try {
				omdUrl = imageService.getServingUrl(omdOpts);
			}
			catch (Exception e2) {
				omdUrl = "img/logo_omd.png";
			}
		}
	}%>
<%
	setUrls();
%>
<div data-role="page" id="home">
	<div data-theme="a" data-role="header">
		<h3>Monumentendag</h3>
			<a id="loginLink" data-rel="dialog" data-role="button" data-transition="slidedown" data-mini="true" href="#login">
			Inloggen </a>
			<a class="ui-btn-right messagesLink" data-icon="custom-message" data-rel="dialog" data-role="button" data-transition = "slidedown" data-mini="true" href="#messages">0 Berichten</a>
	</div>
	<div data-role="content">
		<div style="text-align: center">
			<img src="<%=omdUrl %>" alt="Open Monumenten Dag" />
		</div>
		<div class="ui-grid-a">
			<div class="ui-block-a">
				<a data-role="button" data-transition="fade" href="#locations"> Locaties </a>
			</div>
			<div class="ui-block-b">
				<a data-role="button" data-transition="fade" href="#map"> Kaart </a>
			</div>
			<div class="ui-block-a">
				<a data-role="button" data-transition="fade" href="#thema"> OMD Thema </a>
			</div>
			<div class="ui-block-b">
				<a data-role="button" data-transition="fade" href="#voorwoord"> OMD Delft </a>
			</div>

			<div class="ui-block-a">
				<a data-role="button" data-transition="fade" href="#wandel"> Wandelen </a>
			</div>
			<div class="ui-block-b">
				<a data-role="button" data-transition="fade" href="#social"> Social </a>
			</div>
		</div>
		<div class="ui-grid-solo">
			<div class="ui-block-a">
				<a data-role="button" data-icon="info" data-transition="fade" data-mini="true" href="#info" data-rel="dialog"> Info </a>
			</div>
		</div>
	</div>
</div>