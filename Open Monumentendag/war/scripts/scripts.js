// global user object
var user = new Object();
// global update object
var updates = [];

var prevLiked = false;

function initializeUser() {
	// get persisted or new user
	var pUser = getPersistedUser();
	// if there was something persisted
	if (!(pUser === null)) {
		// see if the server still knows us
		getUserById(pUser.id, pUser.key);
	} else {
		getNewUser();
	}
}

function getNewUser() {
	var url = "/user?action=new";
	getSyncJSON(url, null, function(data) {
		// console.log("Got new user: " + data.id);
		// store the new User
		setUser(data);
	});
}

function getUserById(id, key) {
	var url = "/user?action=get&userID=" + id + "&key=" + key;
	getSyncJSON(url, null, function(data) {
		// check if the user exists
		if (data != null && typeof data.id !== "undefined" && data.id != null) {
			// console.log("Retrieved existing user");
			setUser(data);
		} else {
			getNewUser();
		}
	});
}

function setUser(newUser) {
	user = newUser;
	// check fifo queue of updates
	while (updates.length > 0) {
		// console.log("Processing queue... Items left: " + updates.length);
		var update = updates.shift();
		setProperties(update);
	}
}

function updateEmail(e) {
	setProperties({
		email : e
	});

}

function updateLocation(latitude, longitude) {
	setProperties({
		lng : longitude,
		lat : latitude
	});
}

function checkLoggedInAndShowHideBlocks() {
	if (isLoggedIn()) {
		$("#loginLink .ui-btn-text").text("Ingelogd");
		$(".loggedIn").show();
		$(".notLoggedIn").hide();
	} else {
		$("#loginLink .ui-btn-text").text("Inloggen");
		$(".loggedIn").hide();
		$(".notLoggedIn").show();
	}
}

function setProperties(data) {
	if (typeof user === "undefined" || typeof user.id === "undefined" || user.id === null) {
		// console.warn("User is still null, update is queued.");
		updates.push(data);
		return;
	}
	// update user object
	for (p in data) {
		user[p] = data[p];
	}
	// update user object on server
	var url = "/user?action=update&userID=" + user.id + "&key=" + user.key;
	for (p in data) {
		url = url + "&" + p + "=" + data[p];
	}
	$.getJSON(url, function(data) {
		if (data) {
			// console.log("User updated on server");
			checkLoggedInAndShowHideBlocks();
			persistUser(user);
		} else {
			console.warn("User could not be updated on server");
		}
	});
}

function isLoggedIn() {
	return typeof user.email !== "undefined" && user.email !== null && user.email !== "";

}

function storeComment() {
	$.getJSON("/comment", {
		action : "set",
		comment : $("#comment").val(),
		userID : user.id,
		locationID : $.mobile.pageData.id,
		key : user.key,
		cache : false
	}, function(data) {
		$("#currentComment").text($("#comment").val());
		$("#comment").val("");
		$("#deleteComment").show();
	});
}

function loadMessages() {
	var list = $("#messageList");
	list.empty();
	$.getJSON("/message", null, function(data) {
		$.each(data, function(index, value) {
			var li = "<li>";
			li += "<h3>" + value.content + "</h3>";
			li += "<p>" + value.author + "</p>";
			li += "<p class='ui-li-aside'>" + new Date(value.dateCreated).toLocaleDateString() + "</p>";
			li += "</li>";
			list.append(li);
		});
		$(".messagesLink .ui-btn-text").text(data.length + " Berichten");
	});

}

function flagComment(id) {
	alert(id);
}

function initButtons(id){
	$('#like_btn').removeClass('ui-disabled');	
	$('#dislike_btn').removeClass('ui-disabled');
	$('#like_btn').unbind("click");
	$('#dislike_btn').unbind("click");
	
	$.getJSON("/like",{action: "get", locationID: id, userID: user.id, key: user.key}, function(data){
		$('#like_count').html(data.like);
		$('#dislike_count').html(data.dislike);
		if(data.userStatus == "LIKE"){
			prevLiked = true;
			$('#like_btn').addClass('ui-disabled');
		}else if(data.userStatus == "DISLIKE"){
			$('#dislike_btn').addClass('ui-disabled');
			prevLiked = true;
		}else{
			prevLiked = false;
		}
	});
	
	
	$('#like_btn').click(function(){
		
		$.getJSON("/like",{action: "set", status: "LIKE", locationID: id, userID: user.id, key: user.key},
				function(data){	});
		
		$('#like_btn').addClass('ui-disabled');			
		$('#dislike_btn').removeClass('ui-disabled');		
		$('#like_count').html(parseInt($('#like_count').html())+1);
		if(prevLiked){
			$('#dislike_count').html(parseInt($('#dislike_count').html())-1);
		}
		prevLiked = true;

	});
	$('#dislike_btn').click(function(){
			
		$.getJSON("/like",{action: "set", status: "DISLIKE", locationID: id, userID: user.id, key: user.key}, 
				function(data){	});
		
		$('#like_btn').removeClass('ui-disabled');
	    $('#dislike_btn').addClass('ui-disabled');
	    $('#dislike_count').html(parseInt($('#dislike_count').html())+1);
	    if(prevLiked){
	    	$('#like_count').html(parseInt($('#like_count').html())-1);
	    }
	    prevLiked = true;
	});
	
	
}

// Make sure we can use the url parameters on anchors.
$(document).bind("pagebeforechange", function(event, data) {
	$.mobile.pageData = (data && data.options && data.options.pageData) ? data.options.pageData : null;
}

);

// apply triggers/events
$(document)
	.bind("mobileinit", function() {
		// init user
		initializeUser();
		// control binds
		$('.googleLogout').click(function() {
			updateEmail("");
		});

		$("[data-role='page']").live("pagebeforeshow", function() {
			checkLoggedInAndShowHideBlocks();
			loadMessages();
		});

		$('#messages').live('pagebeforeshow', function(event, ui) {
			$("#messageList").listview("refresh");
		});

		$('#detail').live('pageshow', function(event, ui) {
			// store comment option 1
			$("#comment").keypress(function(e) {
				if (e.which === 13) {
					storeComment();
				}
			});
			// store comment option 2
			$("#submitComment").click(function() {
				storeComment();
			});
			// delete current comment
			$("#deleteComment").click(function() {
				$.getJSON("/comment", {
					action : "delete",
					userID : user.id,
					locationID : $.mobile.pageData.id,
					key : user.key,
					cache : false
				}, function(data) {
					$("#currentComment").text("U heeft nog geen reactie geplaatst...");
					$("#deleteComment").hide();
				});
			});
		});

		$('#detail')
			.live('pagebeforeshow', function(event, ui) {
				initButtons($.mobile.pageData.id);
				// set current comment
				$.getJSON("/comment", {
					action : "get",
					userID : user.id,
					locationID : $.mobile.pageData.id,
					key : user.key,
					cache : false
				}, function(data) {
					if (data === null || data.length === 0) {
						$("#currentComment").text("U heeft nog geen reactie geplaatst...");
						$("#deleteComment").hide();
					} else {
						$("#currentComment").text(data[0].comment);
						$("#deleteComment").show;
					}
				});

				// set location data
				if (supports_local_storage()) {
					// if the browser if capable of localStorage load cached
					// information
					loadLocation($.mobile.pageData.id);
				} else {
					// TODO: ASK DB
				}

				// load all comments
				$
					.getJSON("/comment", {
						action : "get",
						locationID : $.mobile.pageData.id,
						cache : false
					}, function(data) {
						$("#allComments").empty();
						var allc = $("#allComments");
						var count = data.length;
						$
							.each(data, function(index, value) {
								// check for own comment
								if (value.userID !== user.id) {
									// write listitem
									var li = "<li>";
									li += "<h3 id='li" + index + "'></h3>";
									li += "<p>" + new Date(value.date).toLocaleDateString() + "</p>";
									li += "<p class='ui-li-aside'><a href='' onclick='flagComment("
										+ value.id
										+ ");' alt='Meld reactie als ongepast' title='Meld reactie als ongepast'><img src='img/exclamation-icon-18px.png' /></a></p>";
									li += "</li>";
									allc.append(li);
									$("#li" + index).text(value.comment);
								} else {
									count--;
								}
							});
						$("#commentCount").text("(" + count + ")");
						// reload list
						allc.listview("refresh");
					});

			});

		$('#home').live('pageshow', function(event, ui) {
			$('#home').css('background-image','url(http://lh4.ggpht.com/UVhVjsJLUqNP8dPnCfiuLZ2SF99NtQWmKUEJ3O_szFk7MBQ0sVGUz_dNMVLo5FBXCVBxwi1Nomr45DOXDWS7K2Jc0UME4TwU=s'+Math.floor($("body").width()*0.8)+')');
			// ask location permission on first screen
			if (navigator.geolocation) {
				console.log("found gps");
				navigator.geolocation.watchPosition(updateDistances, displayError, {
					enableHighAcuracy : true
				});
			}
		});

		$("#map").live("pagebeforeshow", function(event, ui) {
			if (navigator.geolocation)
				navigator.geolocation.watchPosition(displayCurrentLocation, displayError);

			// set map height
			$('#map_canvas').height($(window).height() - (62 + $('[data-role=header]').last().height()) - $('#mapinfo').height());

			setMarkers();

			if (localStorage.getItem("mapsUsed") == null) {
				$("#map_canvas").gmap("option", "center", new google.maps.LatLng(52.012443, 4.356047));
				$("#map_canvas").gmap("option", "zoom", 15);
				$("#map_canvas_rz").gmap("option", "streetViewControl", false);
				// localStorage.setItem("mapsUsed",true);
			}
			// $("#map_canvas").gmap("refresh");
		});

		$("#map").live("pageshow", function(event, ui) {
			$("#map_canvas").gmap("refresh");
		});

		$("#userUpload").live("pagebeforeshow", function(event, ui) {
			if (Modernizr.fileinput) {
				$("#noFileUpload").hide();
				$("#fileUpload").show();
				var locationID = $.mobile.pageData.id;
				$.getJSON("/userUpload", {
					locationID : locationID,
					userID : user.id,
					key: user.key,
					path : "/#detail"
				}, function(data) {
					$("#userUploadForm").attr("action", data);
				});
			} else {
				$("#noFileUpload").show();
				$("#fileUpload").hide();
			}
		});

		$("#social").live("pagebeforeshow", function(event, ui) {
			loadTweets('delft');
		});

		$("#routenoord")
			.live("pagebeforeshow", function(event, ui) {
				if (navigator.geolocation)
					navigator.geolocation.watchPosition(displayCurrentLocation, displayError);

				$('#map_canvas_rn').height($(window).height() - (60 + $('#rnlist').height() + $('[data-role=header]').last().height()));

				$("#map_canvas_rn").gmap("option", "center", new google.maps.LatLng(52.01625506283269, 4.350918531417847));
				$("#map_canvas_rn").gmap("option", "zoom", 16);
				$("#map_canvas_rn").gmap("option", "streetViewControl", false);

				setMarker('#map_canvas_rn', 0, 'A - Nieuwe Plantage', 52.01795858690878, 4.35508668422699, "A", 'Nieuwe Plantage');
				setMarker('#map_canvas_rn', 0, 'B - Nolthensiusplantsoen', 52.018747999975396, 4.352219028431733, "B", '');
				setMarker('#map_canvas_rn', 0, 'C - Kalverbos', 52.01717656212665, 4.3515323829261, "C", '');
				setMarker('#map_canvas_rn', 0, 'D - Agnetapark - Oude Park', 52.016100293430895, 4.346371812796633, "D", '');
				setMarker('#map_canvas_rn', 0, 'E - Agnetapark - Nieuwe Park', 52.015340947178366, 4.343936367018501, "E", '');

				var coordinates = [ new google.maps.LatLng(52.01795858690878, 4.35508668422699),
					new google.maps.LatLng(52.01792887483538, 4.354378581047058),
					new google.maps.LatLng(52.01750009795959, 4.353393835984633),
					new google.maps.LatLng(52.01769157724925, 4.352535529102361),
					new google.maps.LatLng(52.019441263831105, 4.352476520496407),
					new google.maps.LatLng(52.01946767367031, 4.352143926579544),
					new google.maps.LatLng(52.018747999975396, 4.352219028431733),
					new google.maps.LatLng(52.01946767367031, 4.352143926589544),
					new google.maps.LatLng(52.019441263831105, 4.352476520496407),
					new google.maps.LatLng(52.01769157724925, 4.352535529102361),
					new google.maps.LatLng(52.01738785109913, 4.351811332662692),
					new google.maps.LatLng(52.01701149192108, 4.35195080753104),
					new google.maps.LatLng(52.0162455582017, 4.350877923928136),
					new google.maps.LatLng(52.01538056556224, 4.350545330011281),
					new google.maps.LatLng(52.01508342682692, 4.3500732612261),
					new google.maps.LatLng(52.01486552383346, 4.349043292967484),
					new google.maps.LatLng(52.0155390387475, 4.347895307512553),
					new google.maps.LatLng(52.015756938460676, 4.347670001955955),
					new google.maps.LatLng(52.016159719984984, 4.347648544283885),
					new google.maps.LatLng(52.016800201170554, 4.3470370006303405),
					new google.maps.LatLng(52.01675398118581, 4.346135778404058),
					new google.maps.LatLng(52.0163842195886, 4.345470590570369),
					new google.maps.LatLng(52.015426786965996, 4.346039218879789),
					new google.maps.LatLng(52.01540697779884, 4.345588607766647),
					new google.maps.LatLng(52.01527491646033, 4.345331115702013),
					new google.maps.LatLng(52.01589560136208, 4.344547910672048),
					new google.maps.LatLng(52.01522869489978, 4.343099517808391),
					new google.maps.LatLng(52.01485892069602, 4.343485755905355),
					new google.maps.LatLng(52.01514575646878, 4.3442559242248535) ];
				drawPolyLine('#map_canvas_rn', coordinates);
				/* void(prompt('',gApplication.getMap().getCenter())); */

			});

		$("#routenoord").live("pageshow", function(event, ui) {
			$('#map_canvas_rn').height($(window).height() - (60 + $('#rnlist').height() + $('[data-role=header]').last().height()));
			$("#map_canvas_rn").gmap("refresh");
		});

		$("#routezuid").live("pagebeforeshow", function(event, ui) {
			if (navigator.geolocation)
				navigator.geolocation.watchPosition(displayCurrentLocation, displayError);

			$('#map_canvas_rz').height($(window).height() - (18 + $('#rzlist').height() + $('[data-role=header]').last().height()));

			$("#map_canvas_rz").gmap("option", "center", new google.maps.LatLng(52.00631927080595, 4.371507167816162));
			$("#map_canvas_rz").gmap("option", "zoom", 16);
			$("#map_canvas_rz").gmap("option", "streetViewControl", false);

			setMarker('#map_canvas_rz', 0, 'A - Nieuwe Plantage', 52.006831686309845, 4.365434646606445, "A", '');
			setMarker('#map_canvas_rz', 0, 'B - Nolthensiusplantsoen', 52.00382001372848, 4.372698068618774, "B", '');
			setMarker('#map_canvas_rz', 0, 'C - Kalverbos', 52.006580721335155, 4.369994401931763, "C", '');
			setMarker('#map_canvas_rz', 0, 'D - Agnetapark - Oude Park', 52.0085884017274, 4.37055230140686, "D", '');

			var coordinates = [ new google.maps.LatLng(52.006831686309845, 4.365434646606445),
				new google.maps.LatLng(52.00691754242548, 4.364715814590454), new google.maps.LatLng(52.00738644599683, 4.365681409835815),
				new google.maps.LatLng(52.00634956813972, 4.366518259048462), new google.maps.LatLng(52.00638259009789, 4.366711378097534),
				new google.maps.LatLng(52.00601274277476, 4.36755895614624), new google.maps.LatLng(52.00448048559027, 4.370359182357788),
				new google.maps.LatLng(52.00335767762617, 4.371185302734375), new google.maps.LatLng(52.00382001372848, 4.372698068618774),
				new google.maps.LatLng(52.003654894240164, 4.371185302734375),
				new google.maps.LatLng(52.00451350892753, 4.370434284210205), new google.maps.LatLng(52.00531927080595, 4.368996620178223),
				new google.maps.LatLng(52.00620427123437, 4.370284080505371),
				new google.maps.LatLng(52.006580721335155, 4.369994401931763),
				new google.maps.LatLng(52.00620427123437, 4.370284080505371),
				new google.maps.LatLng(52.007472301048175, 4.372032880783081),
				new google.maps.LatLng(52.00788176133486, 4.371936321258545), new google.maps.LatLng(52.0085884017274, 4.37055230140686) ];
			drawPolyLine('#map_canvas_rz', coordinates);

		});

		$("#routezuid").live("pageshow", function(event, ui) {
			$('#map_canvas_rz').height($(window).height() - (18 + $('#rzlist').height() + $('[data-role=header]').last().height()));
			$("#map_canvas_rz").gmap("refresh");
		});

	});

function displayCurrentLocation(location) {
	console.log("setting current position");
	var loc = new google.maps.LatLng(location.coords.latitude, location.coords.longitude);

	updateCurrentLocation('#map_canvas', loc);
	updateCurrentLocation('#map_canvas_rn', loc);
	updateCurrentLocation('#map_canvas_rz', loc);
}

function updateCurrentLocation(map, location) {
	var marker = $(map).gmap('get', 'markers > client');
	if (!marker) {
		$(map).gmap('addMarker', {
			'id' : 'client',
			'position' : location,
			'animation' : google.maps.Animation.DROP,
			'zIndex' : 2000,
			'bounds' : false,
			'title' : "You are here!"
		});
	} else {
		marker.setPosition(location);
	}
}

function setMarker(map, id, title, lat, lon, marker, content) {
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
	var image2 = new google.maps.MarkerImage('img/beachflag2.png', new google.maps.Size(20, 32), new google.maps.Point(0, 0),
		new google.maps.Point(0, 32));
	var shadow = new google.maps.MarkerImage('img/beachflag_shadow.png',
	// The shadow image is larger in the horizontal dimension
	// while the position and offset are the same as for the main image.
	new google.maps.Size(37, 32), new google.maps.Point(0, 0), new google.maps.Point(0, 32));
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
	var icon;
	//console.log(content);
	//console.log(Object.prototype.toString.call(marker));
	if(Object.prototype.toString.call(marker) === '[object Boolean]' ){
		icon = (marker) ? image : image2;
	}else{
		switch(marker){
			case "A": icon = new google.maps.MarkerImage('img/a.png', new google.maps.Size(32, 32), new google.maps.Point(0, 0),
					new google.maps.Point(16, 16));					
					break;
			case "B": icon = new google.maps.MarkerImage('img/b.png', new google.maps.Size(32, 32), new google.maps.Point(0, 0),
					new google.maps.Point(16, 16));
					break;
			case "C": icon = new google.maps.MarkerImage('img/c.png', new google.maps.Size(32, 32), new google.maps.Point(0, 0),
					new google.maps.Point(16, 16));
					break;
			case "D": icon = new google.maps.MarkerImage('img/d.png', new google.maps.Size(32, 32), new google.maps.Point(0, 0),
					new google.maps.Point(16, 16));
					break;
			case "E": icon = new google.maps.MarkerImage('img/e.png', new google.maps.Size(32, 32), new google.maps.Point(0, 0),
					new google.maps.Point(16, 16));
					break;
			default: break;
			
			
		}
	}

	$(map).gmap('addMarker', {
		'position' : myLatLng,
		'shadow' : shadow,
		'icon' : icon,
		'shape' : shape,
		'title' : title,
		'zIndex' : id,
		'bounds' : false
	}).click(function() {
		$(map).gmap('openInfoWindow', {
			'content' : content
		}, this);
	});
}

function drawPolyLine(map, coordinates) {
	var path = new google.maps.Polyline({
		path : coordinates,
		strokeColor : "#FF0000",
		strokeOpacity : 1.0,
		strokeWeight : 2
	});

	path.setMap($(map).gmap('get', 'map'));
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

	var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) + Math.cos(lat1) * Math.cos(lat2) * Math.sin(dLon / 2) * Math.sin(dLon / 2);
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
