<%@page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@page import="com.google.appengine.api.blobstore.BlobstoreService"%>
<%@page import="com.google.appengine.api.blobstore.BlobKey"%>
<%@page import="com.google.appengine.api.images.ServingUrlOptions"%>
<%@ page import="com.google.appengine.api.images.ImagesServiceFactory"%>
<%@ page import="com.google.appengine.api.images.ImagesService"%>
<%!ImagesService imageService = ImagesServiceFactory.getImagesService();
	BlobKey themaKey = new BlobKey(
			"AMIfv966Vg25LEzjMKOjr79g8cuux5oZbuZDy4oT3kJe0O9R5OwyP57mmFGXsBw7xl6IV9uplZnLIePhDiCz-lTrX14IGAPPCdSUB8DphW36JaJV5CLvPtMIxP1X8kFP-CaZwDFtuhV6SNCbzPBwRxmrL6bIhGLWixb7tEK2n33YCdw_VCE_KpQ");
	ServingUrlOptions themaOpts = ServingUrlOptions.Builder.withBlobKey(themaKey).imageSize(300);
	String themaUrl = null;

	void setUrls() {
		if (themaUrl == null) {
			try {
				themaUrl = imageService.getServingUrl(themaOpts);
			}
			catch (Exception e2) {
				themaUrl = "img/thema.jpg";
			}
		}
	}%>
<%
	setUrls();
%>
<div data-role="page" id="thema">
	<div data-theme="a" data-role="header" data-backbtn="true">
		<h3>Thema</h3>
		<a href="/#home" data-icon="back">Back</a>
		<a class="ui-btn-right messagesLink" data-icon="custom-message" data-rel="dialog" data-role="button" data-transition = "slidedown" data-mini="true" href="#messages">0 Berichten</a>
	</div>
	<div data-role="content">
		<div style="text-align: center">
			<img class="center themaImg" alt="Themabeeld van Groen van Toen"
			src="<%=themaUrl %>"/>
		</div>
		<br />
		<span class="fineprint"> (bron: <a
			href="http://www.openmonumentendag.nl/bezoeken/bezoek-open-monumentendag/thema-2012-groen-van-toen/">Open
				Monumentendag</a>)
		</span>
			<p>
			<strong>Ooit een houtwal bezocht? Om een terp heen
				gewandeld? Ziet u het verschil tussen een aangelegd bos en de wilde
				variant? Op Open Monumentendag kunt u dit jaar ontdekken hoe de
				natuur in ons land door de eeuwen heen door mensenhanden is bewerkt.
				Met het thema Groen van Toen duiken we in de geschiedenis van het
				Nederlandse landschap.</strong>
		</p>
		<p>Natuurlijk weten we dat tuinen en parken zijn ontworpen en
			aangelegd, maar in Nederland is vrijwel alle natuur bewerkt; van
			wilde duinenrijen en zandvlaktes tot monumentale beukenbossen. Ons
			land is ontbost, ontveend, beploegd en bezaaid, bebouwd of juist weer
			herbebost. Zorgvuldig ontworpen en aangelegd om het beter te kunnen
			gebruiken, om bewoners tegen de elementen te beschermen of alleen
			maar om het uitzicht mooier te maken. Ons landschap is kortom een
			belangrijk onderdeel van ons culturele erfgoed.</p>

		<p>Daarom gaan we dit jaar met Open Monumentendag niet alleen naar
			binnen, maar ook naar buiten: de paden op, de lanen in! U kunt dit
			jaar buitenplaatsen, landgoederen, parken en plantsoenen bezoeken,
			maar ook een protserig prieeltje, een kleine kruidentuin, een
			boerenerf of een van de vele verdedigingswerken.</p>
		<p>Aanleiding om dit jaar voor Groen van Toen te kiezen, is het
			feit dat 2012 is uitgeroepen tot het Jaar van de Historische
			Buitenplaats. Tijdens Open Monumentendag zal, naast alle aandacht
			voor de groene monumenten, ook de relatie tussen groen en de gebouwde
			monumenten centraal staan. Welke rol speelde (en speelt nog steeds!)
			een park, een tuin, een plantsoen of een begraafplaats in relatie tot
			het gebouwde monument? Een thema waarmee we zowel het Toen als het
			Groen centraal kunnen stellen.</p>
		<p>
			Voor meer informatie over de Open Monumentendag kijkt u op <a
				href="http://www.openmonumentendag.nl/">openmonumentendag.nl</a>.
		</p>
	</div>
</div>