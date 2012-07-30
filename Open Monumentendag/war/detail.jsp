<div data-role="page" id="detail">
	<div data-theme="a" data-role="header" style="background: #d06516; color: #fff; border-color: #d06516;">
		<h3 class="locationName">OMD Delft</h3>
	</div>
	<div data-role="content">
		<h3 style="color: #d06516; margin: 0em;">
			<span class="locationName"></span>
		</h3>
		<span style="color: #d06516;">&#47;</span>
		<p style="margin: 0em;"><span id="locationAdres" style="color: #d06516;"></span></p>
		<span style="color: #d06516;">&#47;</span>
		<div style="width: 288px; height: 200px; position: relative; margin: auto; background-color: #fbfbfb; border: 1px solid #b8b8b8; overflow: hidden;">
			<div id="locationImageURL">
			</div>
			<div id="locationNumber" 
				style="background: #d06516; color: #fff; width: 30px; height: 30px; padding: 5px; font-size: x-large; position: absolute; top: 0px; left: 0px;">16</div>
			<div id="locationWheelChair" 
				style="width: 30px; height: 30px; font-size: x-large; position: absolute; top: 40px; left: 0px; display:none;"><img src="img/wheelchair.png" width="40px" height="40px"/></div>
		</div>
		
		<div>
			
			<p id="locationOpenSaLabel"><i>Zaterdag <span id="locationOpenSa"/></i></p>
			<p id="locationOpenSuLabel"><i>Zondag <span id="locationOpenSu"/></i></p>
			<p id="locationInformationLabel"><b style="color: #d06516;">Overige informatie:</b><br/><span id="locationInformation"></span></p>
			<p><b style="color: #d06516;">Omschrijving:</b><br/><span id="locationDescription"></span></p>
		</div>
		<ul id="Gallery" class="gallery">
		</ul>
	</div>
</div>