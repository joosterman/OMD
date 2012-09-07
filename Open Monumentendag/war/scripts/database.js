function getPersistedUser() {
	if (supports_local_storage) {
		return $.parseJSON(localStorage.getItem("user"));
	} else {
		console.error("User storage not implemented");
		return null;
	}
}

function persistUser(user) {
	if (supports_local_storage) {
		localStorage.setItem("user", $.toJSON(user));
	} else {
		console.error("User storage not implemented");
	}
}

function cacheLocations() {
	var locArray = localStorage.getItem("locArray"); 
	if ( locArray === null || locArray===""  ) {
		var jsonObj = getSyncJSON("/data", {}, parseLocations);
	}
}

function parseLocations(locations) {
	localStorage.setItem("locArray", "");
	var locationArray = $.evalJSON($.toJSON([]));

	for (i = 0; i < locations.length; i++) {

		locations[i].name = locations[i].name.replace('<p>', '').replace('</p>', '');
		locations[i].visited = false;

		var key = 'loc-' + locations[i].id;
		localStorage.setItem(key, $.toJSON(locations[i]));

		locationArray[i] = {
			location : key,
			topLocation : locations[i].topLocation
		};

	}

	localStorage.setItem("locArray", $.toJSON(locationArray));
}

function loadLocation(id) {
	var location = $.evalJSON(localStorage.getItem('loc-' + id));

	$( "#locInfoBlock" ).trigger("expand");
	
	$('.locationName').html(location.name);
	$('#locationStreet').html(location.street /* +', '+location.city */);
	$('#locationOpen').html(location.openingstijden);
	$('#locationNumber').html(location.number);
	$("#comment_LocationID").val(id);
	if (parseInt(location.number) < 10 || location.number == "S" || location.number == "D") {
		$('#locationNumber').addClass("locationNumberSD");
		$('#locationNumber').removeClass("locationNumberDD");
	} else {
		$('#locationNumber').addClass("locationNumberDD");
		$('#locationNumber').removeClass("locationNumberSD");
	}

	// console.log(location)
	$('#locationDescription').html(location.description);
	$('#locationOpenSa').html(location.openingHoursSaturday);
	$('#locationOpenSu').html(location.openingHoursSunday);
	$('#locationInformation').html(location.info);

	if (location.wheelchairFriendly) {
		$('#locationWheelChair').show();
	} else {
		$('#locationWheelChair').hide();
	}

	if (location.tourAvailable)
		$('#locationInformation').append("<br/>Op deze locatie worden rondleidingen gegeven.");
/*
	if (location.topLocation)
		$('#locationInformation').append("<br/>Dit is een toplocatie.");
*/
	if ($('#locationInformation').html() == "") {
		$('#locationInformationLabel').hide();
	} else {
		$('#locationInformationLabel').show();
	}

	if (location.openingHoursSaturday == "") {
		$('#locationOpenSaLabel').hide();
	} else {
		$('#locationOpenSaLabel').show();
	}

	if (location.openingHoursSunday == "") {
		$('#locationOpenSuLabel').hide();
	} else {
		$('#locationOpenSuLabel').show();
	}

	// Set colors
	var color = "";
	var theme = "";
	if (location.number == "S" || location.number == "D") {
		color = "yellow";
		theme = "j";
	} else if (location.topLocation) {
		color = "green";
		theme = "i";
	} else if (parseInt(location.number) <= 18) {
		color = "orange";
		theme = "f";
	} else if (parseInt(location.number) <= 38) {
		color = "blue";
		theme = "h";
	} else {
		color = "pink";
		theme = "g";
	}
	
	$('#detailHeader').attr('data-theme', theme);
	$('#detailHeader').attr('class', 'ui-header ui-bar-'+theme);
	$('#backBtnDetail').attr('data-theme', theme);
	$('#backBtnDetail').attr('class','ui-btn-left ui-btn ui-btn-up-'+theme+' ui-shadow ui-btn-corner-all ui-btn-icon-left');
	$('#msgBtnDetail').attr('data-theme', theme);
	$('#msgBtnDetail').attr('class','ui-btn-right messagesLink ui-btn ui-btn-up-'+theme+' ui-shadow ui-btn-corner-all ui-mini ui-btn-icon-left');
	
	$('#locationNumber').removeClass("orangeBackground pinkBackground blueBackground greenBackground yellowBackground");
	$('#title').removeClass("orangeColor pinkColor blueColor greenColor yellowColor");
	$('#detailInformation').find('strong').removeClass("orangeColor pinkColor blueColor greenColor yellowColor");
	
	$('#locationNumber').addClass(color + "Background");
	$('#title').addClass(color + "Color");
	$('#detailInformation').find('strong').addClass(color + "Color");

	//load image upload fields
	$(".userID").val(user.id);
	$(".locationID").val(id);	
	$("#userUploadLink").attr("href","/#userUpload?id="+id);
	
	//set twitter link
	$("#tweetLink").attr("href","https://twitter.com/intent/tweet?text="+location.name+" %23OMDDelft");
	
	//set login link
	$(".loginLink").attr("href","/#login?returnUrl="+encodeURIComponent("/#detail?id="+location.id));
	
	loadLocationImages(location.id);
}

function loadLocationImages(id) {
	var jsonObj = $.getJSON("/images?locationID=" + id, {}, parseLocationImages);
}

function parseLocationImages(locations) {	
	var imageCount = 0;
	//console.log(locations);
	var systemImages = locations['systemImages'];
	var userImages = locations['userImages'];
	var primarySet = false;
	var galleryList = $("#Gallery");
	galleryList.empty();

	var result = "";
	var bodyWidth = Math.floor($("body").width()*0.8);
	bodyWidth = bodyWidth>1000?1000:bodyWidth;
	for (i = 0; i < systemImages.length; i++) {
		if (systemImages[i].primary) {
			$('#locationImageURL').html('<a href="' + systemImages[i].imageURL + "=s" + bodyWidth*2 + '"><img src="' + systemImages[i].imageURL + "=s" + bodyWidth
				+ '" alt="' + systemImages[i].filename + '" id="primaryImage"/></a>');
			$("#locationImageURL a").photoSwipe({captionAndToolbarAutoHideDelay: 0});
			primarySet = true;
		} else {
			if (systemImages[i].imageURL != undefined){
				result += '<li><a href="' + systemImages[i].imageURL + "=s" + bodyWidth*2 +'"><img src="' + systemImages[i].imageURL + '=s' + Math.floor(bodyWidth/3) + '-c" alt="'
					+ systemImages[i].filename + '" /></a></li>';
			imageCount++;
			}
					
		}
	}
	for (i = 0; i < userImages.length; i++) {
			if (userImages[i].imageURL != undefined && userImages[i].adminApproved!==false && (userImages[i].flagged < 2 || userImages[i].adminApproved)){
				result += '<li><a href="' + userImages[i].imageURL + "=s" + bodyWidth*2 +'"><img src="' + userImages[i].imageURL + '=s' + Math.floor(bodyWidth/3) + '-c" alt="Gebruikersfoto" /></a></li>';
			imageCount++;
			}
	}
	$("#imageCount").text("("+imageCount+")");
	if (imageCount > 0) {
		galleryList.append(result);
		$("#Gallery a").photoSwipe({captionAndToolbarAutoHideDelay: 0});
	}
	if(!primarySet){
		// Remove old image if no new image is found
		$('#locationImageURL').html('');
	}

}

function updateDistances(location) {
	var lat1 = location.coords.latitude, lon1 = location.coords.longitude;
	// console.log(lat1 + " " + lon1);
	// Update the server with the new location
	updateLocation(lat1, lon1);

	var locationArray = $.evalJSON(localStorage.getItem("locArray"));
	// console.log(locationArray);
	for (i = 0; i < locationArray.length; i++) {
		// console.log(locationArray[i].location);

		var location = $.evalJSON(localStorage.getItem(locationArray[i].location));
		// console.log(location);

		if (location.latitude != null && location.longitude != null) {

			$('#location-' + location.id + ' span.ui-li-count')
				.html(calculateDistance(lat1, lon1, parseFloat(location.latitude), parseFloat(location.longitude)));
			$('#location-' + location.id + ' span.ui-li-count').css({
				"visibility" : "visible"
			});

		}
	}
}

function setMarkers() {
	// For each location put a marker on a map
	var locationArray = $.evalJSON(localStorage.getItem("locArray"));

	for (i = 0; i < locationArray.length; i++) {

		var location = $.evalJSON(localStorage.getItem(locationArray[i].location));

		if (location.latitude != undefined && location.longitude != undefined) {
			// if(location.latude > 1 && location.longitude > 1){
			//console.log("Setting marker!");
			//console.log(location.topLocation);

			setMarker('#map_canvas', location.id, location.name, location.latitude, location.longitude, location.topLocation, '<strong>'
				+ location.name + '</strong></br>' + location.street + '<br/>Zaterdag: ' + location.openingHoursSaturday + '<br/>Zondag: '
				+ location.openingHoursSunday + '<br/><a href="#detail?id=' + location.id + '">Detail pagina</a>');
			// }
		}
	}
}

function setVisited(id) {

	var location = $.evalJSON(localStorage.getItem('loc-' + id));
	location.visited = true;
	localStorage.setItem('loc-' + id, $.toJSON(location));
}

function init() {
	// load data
	cacheLocations();
}

function supports_local_storage() {
	try {
		return 'localStorage' in window && window['localStorage'] !== null;
	} catch (e) {
		return false;
	}
}

function getSyncJSON(url, data, success) {
	$.ajax({
		type : 'GET',
		url : url,
		dataType : 'json',
		success : success,
		data : data,
		async : false
	});
}

$(document).ready(function(e) {
	init();
});