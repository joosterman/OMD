//Make sure we can use the url parameters on anchors.
$(document)
		.bind(
				"pagebeforechange",
				function(event, data) {
					$.mobile.pageData = (data && data.options && data.options.pageData) ? data.options.pageData
							: null;
				});

// apply triggers/events
$(document).bind("mobileinit", function() {
	$('#detail').live('pagebeforeshow', function(event, ui) {
		$.getJSON("/location", {
			id : $.mobile.pageData.id
		}, function(data) {
			$('#locationName').html(data.name);
			$('#locationImageURL').attr("src", data.imageURL);
			$('#locationDescription').html(data.description);
		});
	});
	// ask location permission on first screen
	$('#home').live('pageshow', function(event, ui) {
		// if (navigator.geolocation)
		// navigator.geolocation.getCurrentPosition(displayLocation,
		// displayError);
	});
	$("#map").live("pagebeforeshow", function(event, ui) {
		$("#map_canvas").gmap({
			'callback' : function() {
				if (navigator.geolocation)
					 navigator.geolocation.getCurrentPosition(displayCurrentLocation, displayError);
			}
		});
	});

});

function displayCurrentLocation(location){
	var loc = new google.maps.LatLng(location.coords.latitude,location.coords.longitude);
	$("#map_canvas").gmap("addMarker",{"position":loc, "bounds":false});
	$("#map_canvas").gmap("option","center", loc);
	$("#map_canvas").gmap("option","zoom", 18);
	$("#map_canvas").gmap("refresh");	
}

function displayError(error) {

	// get a reference to the HTML element for writing result
	var locationElement = document.getElementById("mapinfo");

	// find out which error we have, output message accordingly
	switch (error.code) {
	case error.PERMISSION_DENIED:
		locationElement.innerHTML = "Permission was denied";
		break;
	case error.POSITION_UNAVAILABLE:
		locationElement.innerHTML = "Location data not available";
		break;
	case error.TIMEOUT:
		locationElement.innerHTML = "Location request timeout";
		break;
	case error.UNKNOWN_ERROR:
		locationElement.innerHTML = "An unspecified error occurred";
		break;
	default:
		locationElement.innerHTML = "Who knows what happened...";
		break;
	}
}
