function getPersistedUser() {
	if(supports_local_storage){
		return $.parseJSON(localStorage.getItem("user"));
	}else{
		console.error("User storage not implemented");
		return null;
	}
}

function persistUser(user) {
	if(supports_local_storage){
		localStorage.setItem("user", $.toJSON(user));
	}else{
		console.error("User storage not implemented");
	}
}

function cacheLocations() {
	var jsonObj = $.getJSON("/data", {}, parseLocations);
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
		if(locations[i].primary){
			if(locations[i].imageURL == ""){
				$('#locationImageURL').html('<img src="http://codiqa.com/static/images/v2/image.png" alt="image" margin-left: -16px; margin-top: -18px" />');
			}else{
				$('#locationImageURL').html('<a href="'+locations[i].imageURL+'"><img src="'+locations[i].imageURL+'\u003ds300'+'" alt="'+locations[i].description+'" margin-left: -16px; margin-top: -18px" /></a>');
				$("#locationImageURL a").photoSwipe({ enableMouseWheel: false , enableKeyboard: false });
			}
		}else{
			result += '<li><a href="'+locations[i].imageURL+'"><img src="'+locations[i].thumbnailURL+'" alt="'+locations[i].description+'" /></a></li>';
		}
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

function supports_local_storage() {
	try {
		return 'localStorage' in window && window['localStorage'] !== null;
	} catch (e) {
		return false;
	}
}

$(document).ready(function(e) {
	init();
});