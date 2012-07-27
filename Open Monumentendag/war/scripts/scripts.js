//global user object
user = new Object();
user.userId = "565";
user.accessKey = "788fca3b-c546-4917-b140-124f01d222b0";

function getNewUser(){
	var url = "/user?action=newuser";
	$.getJSON(url,function(data){
		//logic
	});
}
function getUserById(id,key){
	var url = "/user?action=get&userId="+id+"&key="+key;
	$.getJSON(url,function(data){
		//logic
	});
}
function getUserByEmail(email,key){
	var url = "/user?action=get&email="+id+"&key="+key;
	$.getJSON(url,function(data){
		//logic
	});
}
function setPropertiesForUser(id,key,data)
{
	var url = "/user?action=get&email="+id+"&key="+key;
	for(p in data){
		url = url+"&"+p+"="+data[p];
	}
	$.getJSON(url,function(data){
		//logic
	});
}


// Make sure we can use the url parameters on anchors.
$(document)
		.bind(
				"pagebeforechange",
				function(event, data) {
					$.mobile.pageData = (data && data.options && data.options.pageData) ? data.options.pageData
							: null;
				});

// apply triggers/events
$(document).bind(
		"mobileinit",
		function() {
			$('#detail').live('pagebeforeshow', function(event, ui) {
				if (supports_local_storage()) {
					// if the browser if capable of localStorage load cached
					// information
					loadLocation($.mobile.pageData.id);
				} else {
					// TODO: ASK DB
				}

			});
			
			$('#detail').live('pageshow', function(event, ui) {
				//$("#Gallery a").photoSwipe({ enableMouseWheel: false , enableKeyboard: false });
			});
			
			$('#detail').live('pagehide', function(event, ui) {
				//$("#Gallery a").photoSwipe({ enableMouseWheel: false , enableKeyboard: false });
			});

			// ask location permission on first screen
			$('#home').live('pageshow', function(event, ui) {
				// if (navigator.geolocation)
				// navigator.geolocation.getCurrentPosition(displayLocation,
				// displayError);
				$('[data-role=content]').height('100%');
			});

			$("#map").live(
					"pagebeforeshow",
					function(event, ui) {
						// $("#map_canvas").gmap({'callback' : function() {
						if (navigator.geolocation)
							navigator.geolocation.getCurrentPosition(
									displayCurrentLocation, displayError);
						// }
						// });

						// set map height
						$('[data-role=content]').height(
								$(window).height()
										- (42 + $('[data-role=header]').last()
												.height()));

						setMarkers();
						// drawPolyLine(monuments);
						// $("#map_canvas").gmap("refresh");
					});

			$("#map").live("pageshow", function(event, ui) {
				$("#map_canvas").gmap("refresh");
			});

			$("#locations").live(
					"pagebeforeshow",
					function(event, ui) {
						loadLocations();
						// ziedelft.webdb.getAllLocations(loadLocations);
						// console.log("loaded Locations");
						if (navigator.geolocation) {
							console.log("found gps");
							navigator.geolocation.watchPosition(
									updateDistances, displayError);

						}
					});

			$("#social").live("pagebeforeshow", function(event, ui) {
				loadTweets('#f1');
			});

		});

function displayCurrentLocation(location) {
	console.log("setting current position");
	var loc = new google.maps.LatLng(location.coords.latitude,
			location.coords.longitude);

	$("#map_canvas").gmap("addMarker", {
		"position" : loc,
		"bounds" : true,
		"title" : "You are here!"
	});
	// $("#map_canvas").gmap("option","center", loc);
	// $("#map_canvas").gmap("option","zoom", 44);
	$("#map_canvas").gmap("option", "mapTypeId", google.maps.MapTypeId.ROADMAP);
	// $("#map_canvas").gmap("refresh");
}

function setMarker(id, title, lat, lon, top) {
	// Add markers to the map

	// Marker sizes are expressed as a Size of X,Y
	// where the origin of the image (0,0) is located
	// in the top left of the image.

	// Origins, anchor positions and coordinates of the marker
	// increase in the X direction to the right and in
	// the Y direction down.
	var image = new google.maps.MarkerImage('img/beachflag.png',
	// This marker is 20 pixels wide by 32 pixels tall.
	new google.maps.Size(20, 32),
	// The origin for this image is 0,0.
	new google.maps.Point(0, 0),
	// The anchor for this image is the base of the flagpole at 0,32.
	new google.maps.Point(0, 32));
	var image2 = new google.maps.MarkerImage('img/beachflag2.png',
			new google.maps.Size(20, 32), new google.maps.Point(0, 0),
			new google.maps.Point(0, 32));
	var shadow = new google.maps.MarkerImage('img/beachflag_shadow.png',
	// The shadow image is larger in the horizontal dimension
	// while the position and offset are the same as for the main image.
	new google.maps.Size(37, 32), new google.maps.Point(0, 0),
			new google.maps.Point(0, 32));
	// Shapes define the clickable region of the icon.
	// The type defines an HTML <area> element 'poly' which
	// traces out a polygon as a series of X,Y points. The final
	// coordinate closes the poly by connecting to the first
	// coordinate.
	var shape = {
		coord : [ 1, 1, 1, 20, 18, 20, 18, 1 ],
		type : 'poly'
	};

	var myLatLng = new google.maps.LatLng(lat, lon);

	$('#map_canvas').gmap('addMarker', {
		'position' : myLatLng,
		'shadow' : shadow,
		'icon' : (top) ? image : image2,
		'shape' : shape,
		'title' : title,
		'zIndex' : id,
		'bounds' : true
	});
}

function drawPolyLine() {
	var coordinates = [ new google.maps.LatLng(52.010903, 4.356808),
			new google.maps.LatLng(52.011667, 4.354444),
			new google.maps.LatLng(52.0125, 4.355278),
			new google.maps.LatLng(52.001667, 4.3725) ];

	var path = new google.maps.Polyline({
		path : coordinates,
		strokeColor : "#FF0000",
		strokeOpacity : 1.0,
		strokeWeight : 2
	});

	path.setMap($('#map_canvas').gmap('get', 'map'));
}

function calculateDistance(lat1, lon1, lat2, lon2) {

	/*
	 * var R = 6371; // km var d = Math.acos(Math.sin(lat1)*Math.sin(lat2) +
	 * Math.cos(lat1)*Math.cos(lat2) * Math.cos(lon2-lon1)) * R;
	 */

	var R = 6371;
	var lat1 = lat1.toRad(), lon1 = lon1.toRad();
	var lat2 = lat2.toRad(), lon2 = lon2.toRad();
	var dLat = lat2 - lat1;
	var dLon = lon2 - lon1;

	var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(lat1)
			* Math.cos(lat2) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
	var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
	var d = R * c;
	return d.toFixed(2) + " km";
}

Number.prototype.toRad = function() {
	return this * Math.PI / 180;
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

function supports_local_storage() {
	try {
		return 'localStorage' in window && window['localStorage'] !== null;
	} catch (e) {
		return false;
	}
}

$(document).ready(function(){

	//var myPhotoSwipe = $("#Gallery a").photoSwipe({ enableMouseWheel: false , enableKeyboard: false });

});