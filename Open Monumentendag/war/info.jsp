<%@page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@page import="com.google.appengine.api.blobstore.BlobKey"%>
<%@page import="com.google.appengine.api.images.ServingUrlOptions"%>
<%@ page import="com.google.appengine.api.images.ImagesServiceFactory"%>
<%@ page import="com.google.appengine.api.images.ImagesService"%>
<%!ImagesService imageService = ImagesServiceFactory.getImagesService();

	BlobKey raboKey = new BlobKey(
			"AMIfv96smlU-Q6zLx5e22tZfhEdJwz9M2tOjZaQpT-Ojoccsrdd3pHxtjdY5nrh0XleG1sylACl_gexU9vV1jncm1fsPzJFH1gPamDBAGAL9ttOvYLl61qjIkxl6vGI9hdMIzdT3IP4B_4KpYs_4Er--mm5ceMfPoEY8LyFKtHThS5SEg2zA8QM");
	ServingUrlOptions raboOpts = ServingUrlOptions.Builder.withBlobKey(raboKey).imageSize(150);
	String raboUrl = null;
	BlobKey omdKey = new BlobKey(
			"AMIfv95pccUZQwNoI4llTrAg0Qv6hZmUFe6L66L8bKyyi7n5ce-sgewexj_ttBwTpISisQNzK9iuvPxH1vPp5VryUtd8MrKH5hF_v643EIZu6v-UdilIg0pulwbet7WRh15aYI0exkuHC2o3nzmH3yTK3QDVX7QP5NAyST_LalV0-IFL0mXL_vg");
	ServingUrlOptions omdOpts = ServingUrlOptions.Builder.withBlobKey(omdKey).imageSize(150);
	String omdUrl = null;

	void setUrls() {
		if (raboUrl == null) {
			try {
				raboUrl = imageService.getServingUrl(raboOpts);
			}
			catch (Exception e1) {
				raboUrl = "img/logo_rabobank.png";
			}
		}
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

<div data-role="page" id="info">
	<div data-theme="a" data-role="header" data-backbtn="true">
		<h3>Informatie</h3>
	</div>
	<div data-role="content">
		<h4>Over de makers</h4>
		<p>Deze webapp is gemaakt door Jasper & Bas. Voor info, tips en klachten mail <a href="mailto:jasper.oosterman+omd@gmail.com">ons</a>.</p>
		<h4>Hoofdsponsor</h4>
		<p>Rabobank is hoofdsponsor van de Open Monumentendag.</p>
		<img class="logo" alt="Logo van de Open Monumentendag" src="<%=omdUrl%>"> <img class="logo"
			alt="Logo van hoofdsponsor Rabobank" src="<%=raboUrl%>">
		<h4>Dankwoord</h4>
		Deze webapp is gefinancierd door het ANWB Fonds.
		<img class="logo"
			alt="Logo ANWB Fonds" src="img/anwb_fonds.png" style="width: 40%; padding-left:25%;">
	</div>

</div>