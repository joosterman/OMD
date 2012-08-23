<div data-role="page" id="detail">
	<div data-theme="a" data-role="header" id="detailHeader">
		<h3 class="locationName"></h3>
		<a href="/#locations" data-icon="back" id="backBtnDetail">Back</a>
	</div>
	<div data-role="content">
		<div id="tweet">
			<a id="tweetLink" href="https://twitter.com/intent/tweet?button_hashtag=omd2012" class="twitter-hashtag-button" data-lang="nl">#omd2012</a>
			<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
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

		<div id="detailInformation">
			<p id="locationOpenSaLabel">
				<em>Zaterdag <span id="locationOpenSa"></span></em>
			</p>
			<p id="locationOpenSuLabel">
				<em>Zondag <span id="locationOpenSu"></span></em>
			</p>
			<p id="locationInformationLabel">
				<strong>Overige informatie:</strong> <br /> <span id="locationInformation"></span>
			</p>
			<p>
				<strong>Omschrijving:</strong> <br /> <span id="locationDescription"></span>
			</p>
		</div>
		<ul id="Gallery" class="gallery"></ul>
		<h4>Reacties</h4>
		<div class="comment">
			<div class="loggedIn">
				<div class="ui-grid-a">
					<div class="ui-block-a" style="width: 80%">
						<input id="comment" data-mini="true" type="text" placeholder="Uw reactie" />
					</div>
					<div class="ui-block-b" style="width: 20%">
						<a id="submitComment" data-iconpos="notext" type="button" data-icon="check" value="Verstuur">Verstuur reactie</a>
					</div>
				</div>
				<i><span id="currentComment"></span></i><a href="" id="deleteComment" data-role="button" data-inline="true"
					data-iconpos="notext" data-icon="delete">Verwijder commentaar</a>
			</div>
			<div class="notLoggedIn">
				U moet ingelogd zijn om commentaar te kunnen geven. Klik <a data-rel="dialog" data-transition="slidedown"
					data-mini="true" href="#login">hier</a> om in te loggen.
			</div>
			<div data-role="collapsible" data-theme="b" data-content-theme="c">
				<h4>Alle reacties</h4>
				<ul data-role="listview" id="allComments"></ul>
			</div>
		</div>
	</div>
</div>