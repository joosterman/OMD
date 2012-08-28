<%@page import="com.google.appengine.api.blobstore.UploadOptions"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreServiceFactory"%>
<%@ page import="com.google.appengine.api.blobstore.BlobstoreService"%>



<div data-role="page" id="detail">
	<div data-theme="a" data-role="header" id="detailHeader">
		<h3 class="locationName"></h3>
		<a href="/#locations" data-icon="back" id="backBtnDetail">Back</a> <a class="ui-btn-right messagesLink"
			data-icon="custom-message" data-rel="dialog" data-role="button" data-transition="slidedown" data-mini="true"
			href="#messages">0 Berichten</a>
	</div>
	<div data-role="content">
		<div id="tweet">
			<a id="tweetLink" href="https://twitter.com/intent/tweet?button_hashtag=omd2012" class="twitter-hashtag-button"
				data-lang="nl">#omd2012</a>
			<script>
				!function(d, s, id) {
					var js, fjs = d.getElementsByTagName(s)[0];
					if (!d.getElementById(id)) {
						js = d.createElement(s);
						js.id = id;
						js.src = "//platform.twitter.com/widgets.js";
						fjs.parentNode.insertBefore(js, fjs);
					}
				}(document, "script", "twitter-wjs");
			</script>
		</div>
		<div id="title">
			<h3 class="locationName"></h3>
			<p id="locationStreet"></p>
		</div>
		<div id="image">
			<div id="locationImageURL"></div>
			<div id="locationNumber"></div>
			<div id="locationWheelChair">
				<img src="img/wheelchair.png" width="40" height="40" alt="Rolstoel vriendelijk" />
			</div>
		</div>
		<div data-role="collapsible-set" data-collapsed-icon="arrow-r" data-expanded-icon="arrow-d" data-inset="false"
			data-theme="c" data-content-theme="d">
			<div data-role="collapsible" data-collapsed="false" id="locInfoBlock">
				<h3>Informatie</h3>
				<div id="detailInformation">
					<p>
						<strong>Open voor publiek</strong>
					<p>
						<span id="locationOpenSaLabel"><i>Zaterdag <span id="locationOpenSa"></span></i><br /></span> <span
							id="locationOpenSuLabel"><i>Zondag <span id="locationOpenSu"></span></i></span>
					</p>
					<p id="locationInformationLabel">
						<strong>Overige informatie:</strong> <br /> <span id="locationInformation"></span>
					</p>
					<p>
						<strong>Omschrijving:</strong> <br /> <span id="locationDescription"></span>
					</p>
				</div>
			</div>
			<div data-role="collapsible" id="locImageBlock">
				<h3>
					Afbeeldingen <span id="imageCount"></span>
				</h3>
				<div class="loggedIn">
					<a id="userUploadLink" href="" data-role="button" data-rel="dialog" data-transition="slidedown">Upload eigen
						foto</a>
				</div>
				<ul id="Gallery" class="gallery"></ul>
			</div>
			<div data-role="collapsible" id="locCommentBlock">
				<h3>
					Reacties <span id="commentCount"></span>
				</h3>
				<div class="comment">
					<div class="loggedIn">
						<div class="ui-grid-a">
							<div class="ui-block-a" style="width: 95%">
								<input id="comment" data-mini="true" type="text" placeholder="Uw reactie" />
							</div>
							<div class="ui-block-b" style="width: 5%">
								<a id="submitComment" data-iconpos="notext" type="button" data-icon="check" value="Verstuur">Verstuur
									reactie</a>
							</div>
						</div>
						<i><span id="currentComment"></span></i><a href="" id="deleteComment" data-role="button" data-inline="true"
							data-iconpos="notext" data-icon="delete">Verwijder reactie</a>
					</div>
					<div class="notLoggedIn">
						U moet ingelogd zijn om een reactie te kunnen plaatsen. Klik <a data-rel="dialog" data-transition="slidedown"
							data-mini="true" href="#login">hier</a> om in te loggen.
					</div>
					<ul data-role="listview" data-theme="c" data-inset="true" id="allComments"></ul>
				</div>
			</div>
		</div>
	</div>
</div>
<div data-role="page" id="userUpload">
	<div data-theme="a" data-role="header" id="detailHeader">
		<h3>Upload foto</h3>
	</div>
	<div data-role="content">
		<div id="noFileUpload">
			<p>Helaas ondersteunt uw browser het uploaden van bestanden niet.</p>
			<p>U kunt uw afbeeldingen ook naar ons <a href="mailto:">emailen</a>.</p>
		</div>
		<div id="fileUpload">
			<form id="userUploadForm" data-ajax="false" action='' method="POST" enctype="multipart/form-data">
				<input type="file" name="userImage" /> <input class="locationID" type="hidden" name="locationID" value="" /> <input
					class="userID" type="hidden" name="userID" value="" /> <input type="submit" accept="image/*" capture="camera"
					value="Upload" data-mini="true" />
			</form>
		</div>

	</div>
</div>