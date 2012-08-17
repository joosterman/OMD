<div data-role="page" id="detail">
	<div data-theme="a" data-role="header" id="detailHeader">
		<h3 class="locationName"></h3>
	</div>
	<div data-role="content">
		<div id="title">
			<h3 class="locationName"></h3>
			<p id="locationStreet"></p>
		</div>
		<div id="image">
			<div id="locationImageURL"></div>
			<div id="locationNumber"></div>
			<div id="locationWheelChair">
				<img src="img/wheelchair.png" width="40" height="40"
					alt="Rolstoel vriendelijk" />
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
				<strong>Overige informatie:</strong> <br /> <span
					id="locationInformation"></span>
			</p>
			<p>
				<strong>Omschrijving:</strong> <br /> <span
					id="locationDescription"></span>
			</p>
		</div>
		<ul id="Gallery" class="gallery"></ul>
		<div class="comment">
			<div class="loggedIn">
				<form action="" method="get">
					<input id="comment_LocationID" type="hidden" name="locationID" />
					<input type="text" name="comment" placeholder="Commentaar" />
					<button type="submit" data-theme="b" data-mini="true">Verstuur</button>
				</form>
			</div>
			<div class="notLoggedIn">
				U moet ingelogd zijn om commentaar te kunnen geven. Klik <a
					data-rel="dialog" data-transition="slidedown" data-mini="true"
					href="#login">hier</a> om in te loggen</a>
			</div>
		</div>
		<div data-role="collapsible">
			<h3>Ander commentaar</h3>
			<p>Hier komt het commentaar</p>
		</div>
	</div>
</div>