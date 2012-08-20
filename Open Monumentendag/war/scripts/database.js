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
	//TODO: Efficient is data outdated check
	if(localStorage.getItem("locArray") == null){
		var jsonObj = getSyncJSON("/data",{}, parseLocations);
		//var jsonObj = $.getJSON("/data", {}, parseLocations);
	}
}

function parseLocations(locations) {
	localStorage.setItem("locArray", "");
	var locationArray = $.evalJSON($.toJSON([]));

	for (i = 0; i < locations.length; i++) {

		locations[i].name = locations[i].name.replace('<p>', '').replace(
				'</p>', '');
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

	$('.locationName').html(location.name);
	$('#locationStreet').html(location.street /* +', '+location.city */);
	$('#locationOpen').html(location.openingstijden);
	$('#locationNumber').html(location.number);
	$("#comment_LocationID").val(id);
	if (parseInt(location.number) < 10 || location.number == "S"
			|| location.number == "D") {
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
		$('#locationInformation').append(
				"<br/>Op deze locatie worden rondleidingen gegeven.");

	if (location.topLocation)
		$('#locationInformation').append("<br/>Dit is een toplocatie.");

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
	if (location.number == "S" || location.number == "D") {
		color = "yellow";
	} else if (location.topLocation) {
		color = "green";
	} else if (parseInt(location.number) <= 18) {
		color = "orange";
	} else if (parseInt(location.number) <= 38) {
		color = "blue";
	} else {
		color = "pink";
	}

	$('#detailHeader')
			.removeClass(
					"orangeBackground pinkBackground blueBackground greenBackground yellowBackground");
	$('#locationNumber')
			.removeClass(
					"orangeBackground pinkBackground blueBackground greenBackground yellowBackground");
	$('#title').removeClass(
			"orangeColor pinkColor blueColor greenColor yellowColor");
	$('#detailInformation').find('strong').removeClass(
			"orangeColor pinkColor blueColor greenColor yellowColor");

	$('#detailHeader').addClass(color + "Background");
	$('#locationNumber').addClass(color + "Background");
	$('#title').addClass(color + "Color");
	$('#detailInformation').find('strong').addClass(color + "Color");
	
	$('#detailHeader').removeClass("orangeBackground pinkBackground blueBackground greenBackground yellowBackground");
	$('#locationNumber').removeClass("orangeBackground pinkBackground blueBackground greenBackground yellowBackground");
	$('#backBtnDetail').removeClass("orangeBackground pinkBackground blueBackground greenBackground yellowBackground");
	$('#title').removeClass("orangeColor pinkColor blueColor greenColor yellowColor");
	$('#detailInformation').find('strong').removeClass("orangeColor pinkColor blueColor greenColor yellowColor");
		
	$('#detailHeader').addClass(color+"Background");
	$('#locationNumber').addClass(color+"Background");
	$('#backBtnDetail').addClass(color+"Background");
	$('#backBtnDetail').css('border-color', '#000');
	$('#title').addClass(color+"Color");
	$('#detailInformation').find('strong').addClass(color+"Color");
	
	loadLocationImages(location.id);
}

function loadLocationImages(id) {
	var jsonObj = $
			.getJSON("/images?locationID=" + id, {}, parseLocationImages);
}

function parseLocationImages(locations) {
	// console.log(locations);
	var galleryList = $("#Gallery");
	galleryList.empty();

	var result = "";

	for (i = 0; i < locations.length; i++) {
		if (locations[i].primary) {
			$('#locationImageURL').html(
					'<a href="' + locations[i].imageURL + '"><img src="'
							+ locations[i].imageURL + '" alt="'
							+ locations[i].description
							+ '" id="primaryImage"/></a>');
			$("#locationImageURL a").photoSwipe({
				enableMouseWheel : false,
				enableKeyboard : false
			});
		} else {
			if (locations[i].imageURL != undefined)
				result += '<li><a href="' + locations[i].imageURL
						+ '"><img src="' + locations[i].thumbnailURL
						+ '" alt="' + locations[i].description
						+ '" /></a></li>';
		}
	}
	if (locations.length > 0) {
		var key = 'img-' + locations[0].id;
		localStorage.setItem(key, $.toJSON(locations));
		
		galleryList.append(result);
		$("#Gallery a").photoSwipe({
			enableMouseWheel : false,
			enableKeyboard : false
		});
	}else{
		//Remove old image if no new image is found
		$('#locationImageURL').html('');
	}

	
}

function updateDistances(location) {
	var lat1 = location.coords.latitude, lon1 = location.coords.longitude;
	//console.log(lat1 + " " + lon1);
	// Update the server with the new location
	updateLocation(lat1, lon1);

	var locationArray = $.evalJSON(localStorage.getItem("locArray"));
	//console.log(locationArray);
	for (i = 0; i < locationArray.length; i++) {
		// console.log(locationArray[i].location);

		var location = $.evalJSON(localStorage
				.getItem(locationArray[i].location));
		//console.log(location);

		if (location.latitude != null && location.longitude != null) {
			//console.log()';'
			$('#location-' + location.id + ' span.ui-li-count').html(
					calculateDistance(lat1, lon1,
							parseFloat(location.latitude),
							parseFloat(location.longitude)));
			$('#location-' + location.id + ' span.ui-li-count').show()

		}

	}
}

function setMarkers() {
	// For each location put a marker on a map
	var locationArray = $.evalJSON(localStorage.getItem("locArray"));

	for (i = 0; i < locationArray.length; i++) {

		var location = $.evalJSON(localStorage
				.getItem(locationArray[i].location));

		if (location.latitude != undefined && location.longitude != undefined) {
			// if(location.latude > 1 && location.longitude > 1){
			console.log("Setting marker!");
			console.log(location.topLocation);

			setMarker('#map_canvas',location.id, location.name, location.latitude,
					location.longitude, location.topLocation,
					location.openingHoursSaturday, location.openingHoursSunday, location.info, location.street);
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

function getSyncJSON(url, data, success){
	$.ajax({
	    type: 'GET',
	    url: url,
	    dataType: 'json',
	    success: success,
	    data: data,
	    async: false
	});
}

$(document).ready(function(e) {
	init();
});
