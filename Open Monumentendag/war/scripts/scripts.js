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
	
	$("#locations").live("pagebeforeshow", function(event, ui) {
		if (navigator.geolocation)
			 navigator.geolocation.getCurrentPosition(calculateDistancesTo, displayError);
	});

});

function displayCurrentLocation(location){
	var loc = new google.maps.LatLng(location.coords.latitude,location.coords.longitude);
	var options = {
	          center: loc,
	          zoom: 18,
	          mapTypeId: google.maps.MapTypeId.ROADMAP
	        };
	var map = new google.maps.Map(document.getElementById("map_canvas"), options);
	
	var marker = new google.maps.Marker({
	    position: loc,
	    title:"You are here!"
	});

	// To add the marker to the map, call setMap();
	marker.setMap(map);
	
	//var map = new google.maps.Map(document.getElementById("map_canvas"));
	setMarkers(map, monuments);
	drawPolyLine(map, locations);
}

var monuments = [
               ['Het meisjeshuis', 52.010903, 4.356808, 4, 1],
               ['Prinsenhof', 52.011667, 4.354444, 5, 1],
               ['TU Delft', 52.001667, 4.3725, 3, 1],
               ['Kruithuis', 51.992795, 4.368932, 2, 0],
               ['Oude Kerk', 52.0125, 4.355278, 1, 0]
             ];

function setMarkers(map, locations) {
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
      new google.maps.Point(0,0),
      // The anchor for this image is the base of the flagpole at 0,32.
      new google.maps.Point(0, 32));
  var image2 = new google.maps.MarkerImage('img/beachflag2.png', new google.maps.Size(20, 32),
	      new google.maps.Point(0,0), new google.maps.Point(0, 32));
  var shadow = new google.maps.MarkerImage('img/beachflag_shadow.png',
      // The shadow image is larger in the horizontal dimension
      // while the position and offset are the same as for the main image.
      new google.maps.Size(37, 32),
      new google.maps.Point(0,0),
      new google.maps.Point(0, 32));
      // Shapes define the clickable region of the icon.
      // The type defines an HTML <area> element 'poly' which
      // traces out a polygon as a series of X,Y points. The final
      // coordinate closes the poly by connecting to the first
      // coordinate.
  var shape = {
      coord: [1, 1, 1, 20, 18, 20, 18 , 1],
      type: 'poly'
  };
  for (var i = 0; i < locations.length; i++) {
    var monument = locations[i];
    var myLatLng = new google.maps.LatLng(monument[1], monument[2]);
    var marker = new google.maps.Marker({
        position: myLatLng,
        map: map,
        shadow: shadow,
        icon: (monument[4] == 1) ? image : image2,
        shape: shape,
        title: monument[0],
        zIndex: monument[3]
    });
  }
}

function drawPolyLine(map, locations){
	 var coordinates = [
      new google.maps.LatLng(52.010903, 4.356808),
      new google.maps.LatLng(52.011667, 4.354444),
      new google.maps.LatLng(52.0125, 4.355278),
      new google.maps.LatLng(52.001667, 4.3725)
    ];
	 
	 var path = new google.maps.Polyline({
		    path: coordinates,
		    strokeColor: "#FF0000",
	    strokeOpacity: 1.0,
	    strokeWeight: 2
	  });
	 
	 path.setMap(map);
}

function calculateDistancesTo(location){
	var lat1 = location.coords.latitude, lon1 = location.coords.longitude
	//TODO: fix this with a foreach
	var lat2 = 52.010903, lon2 = 4.356808;
	
	$('#location-1 span.ui-li-count').html(calculateDistance(lat1, lon1, lat2, lon2));
	$('#location-1 span.ui-li-count').show();
}

function calculateDistance(lat1, lon1, lat2, lon2){
	
	/*var R = 6371; // km
	var d = Math.acos(Math.sin(lat1)*Math.sin(lat2) + 
	                  Math.cos(lat1)*Math.cos(lat2) *
	                  Math.cos(lon2-lon1)) * R;*/
	
	var R = 6371;
	var lat1 = lat1.toRad(), lon1 = lon1.toRad();
	var lat2 = lat2.toRad(), lon2 = lon2.toRad();
	var dLat = lat2 - lat1;
	var dLon = lon2 - lon1;
	
	var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
				Math.cos(lat1) * Math.cos(lat2) * 
				Math.sin(dLon/2) * Math.sin(dLon/2);
	var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
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
