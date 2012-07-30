function cacheLocations() {
	var jsonObj = $.getJSON("/data", {}, parseLocations);
}

function getPersistedUser() {
	console.error("User storage not implemented");
	return null;
}

function persistUser(user) {
	console.error("User storage not implemented");
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

function loadLocations() {
	var locationArray = $.evalJSON(localStorage.getItem("locArray"));

	var locationsList = $("#locations").find(".locationsList");
	locationsList.empty();

	var topLocationsNotSet = true;
	var result = '<li data-role="list-divider" role="heading">Algemeen</li>';

	for (i = 0; i < locationArray.length; i++) {

		var location = $.evalJSON(localStorage
				.getItem(locationArray[i].location));

		if (location.topLocation && topLocationsNotSet) {
			result += '<li data-role="list-divider" role="heading" class="ui-li ui-li-divider ui-bar-e">Groen Top 10</li>';
			topLocationsNotSet = false;
		}

		if (location.number == 1 && location.openingHoursSunday == "") {
			result += '<li data-role="list-divider" role="heading" class="ui-li ui-li-divider ui-bar-d">Alleen Zaterdag</li>';
			topSatOnlyNotSet = false;
		}

		if (location.number == 19 && location.openingHoursSaturday != ""
				&& location.openingHoursSunday != "") {
			result += '<li data-role="list-divider" role="heading" class="ui-li ui-li-divider ui-bar-c">Zaterdag en Zondag</li>';
			topSatSunyNotSet = false;
		}

		if (location.number == 39 && location.openingHoursSaturday == ""
				&& location.openingHoursSunday != "") {
			result += '<li data-role="list-divider" role="heading" class="ui-li ui-li-divider ui-bar-a">Alleen Zondag</li>';
			topSatSunyNotSet = false;
		}

		var id = location.id;
		var text = location.text;

		result += '<li id="location-' + id + '"';
		result += ' data-corners="false" data-shadow="false" data-wrapperels="div" data-icon="arrow-r" data-iconpos="right" data-theme="c"';
		result += ' class="ui-btn ui-btn-icon-right ui-li-has-arrow ui-li ui-li-has-count ui-li-has-thumb ui-btn-hover-c ui-btn-up-c">';
		
		result += '<div class="ui-btn-inner ui-li">';
		result += '<a href="#detail?id=' + id + '"';
		result += ' class="ui-link-inherit"';
		if(localStorage.getItem('android-v') != 'slow'){
			result += ' data-transition="slide"';
		}
		result += '>';
		
		result += '<img src="http://jquerymobile.com/test/docs/lists/images/album-bb.jpg" class="ui-li-thumb">';
		result += '<h3 class="ui-li-heading">' + location.name + '</h3>';
		result += '<p class="ui-li-desc">' + location.street + ', ' + location.city + '</p>';
		result += '<span class="ui-li-count ui-btn-up-c ui-btn-corner-all" style="display: none;"></span>';
		result += '</a>';
		result += '<span class="ui-icon ui-icon-arrow-r ui-icon-shadow">&nbsp;</span>';
		result += '</div">';
		result += '</li>';

		location.visited = false;
	}

	locationsList.append(result);
	locationsList.listview("refresh");
}
  
function loadLocation(id) {
	var location = $.evalJSON(localStorage.getItem('loc-'+id));
	
	$('.locationName').html(location.name);
	$('#locationNumber').html(location.number /*+', '+location.city*/);
	$('#locationAdres').html(location.street /*+', '+location.city*/);
	$('#locationOpen').html(location.openingstijden);
	
	//console.log(location)
	$('#locationDescription').html(location.description);
	$('#locationOpenSa').html(location.openingHoursSaturday);
	$('#locationOpenSu').html(location.openingHoursSunday);
	$('#locationInformation').html(location.info);
	  
	if(location.wheelchairFriendly){
		$('#locationWheelChair').show();
	}else{
		$('#locationWheelChair').hide();
	}
	
	if(location.tourAvailable)
		$('#locationInformation').append("<br/>Op deze locatie worden rondleidingen gegeven.");
	
	if(location.topLocation)
		$('#locationInformation').append("<br/>Toperrrr");
	
	if($('#locationInformation').html() == ""){
		$('#locationInformationLabel').hide();
	}else{
		$('#locationInformationLabel').show();
	}
	
	if(location.openingHoursSaturday == ""){
		$('#locationOpenSaLabel').hide();
	}else{
		$('#locationOpenSaLabel').show();
	}
  
	if(location.openingHoursSunday == ""){
		$('#locationOpenSuLabel').hide();
	}else{
		$('#locationOpenSuLabel').show();
	}
	loadLocationImages(location.id);
}

function loadLocationImages(id){
	var jsonObj = $.getJSON("/images?locationID="+id, 
				{}
				,parseLocationImages
	);
}

function parseLocationImages(locations){
	//console.log(locations);
	var galleryList = $("#Gallery");
	galleryList.empty();
	
	var result = "";
	
	for (i=0; i<locations.length; i++){
		result += '<li><a href="_ah/img/'+locations[i].imageBlobKey.blobKey+'"><img src="_ah/img/'+locations[i].imageBlobKey.blobKey+'=s200" alt="#" /></a></li>';
	}
		
   	var key = 'img-'+locations[0].id;
   	localStorage.setItem(key,$.toJSON(locations));
	
   	galleryList.append(result);
   	$("#Gallery a").photoSwipe({ enableMouseWheel: false , enableKeyboard: false });
}  

function updateDistances(location) {
	var lat1 = location.coords.latitude, lon1 = location.coords.longitude;
	console.log(lat1 + " " + lon1);
	// Update the server with the new location
	updateLocation(lat1, lon1);

	var locationArray = $.evalJSON(localStorage.getItem("locArray"));
	// console.log(locationArray);
	for (i = 0; i < locationArray.length; i++) {
		// console.log(locationArray[i].location);

		var location = $.evalJSON(localStorage
				.getItem(locationArray[i].location));

		if (location.latitude != null && location.longitude != null) {
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

		if (location.latitude != null && location.longitude != null) {

			setMarker(location.id, location.name, location.latitude,
					location.longitude, location.toplocation)
		}
	}
}

function setVisited(id) {
	
	var location = $.evalJSON(localStorage.getItem('loc-'+id));
	location.visited = true;	
	localStorage.setItem('loc-'+id,$.toJSON(location));
} 

function init() {
	// load data
	cacheLocations();
}

$(document).ready(function(e) {
	init();
});