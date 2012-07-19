function cacheLocations(){
	var jsonObj = $.getJSON("/data", 
			{}
			,parseLocations
	);
}

function parseLocations(locations){
	localStorage.setItem("locArray","");	
	var locationArray = $.evalJSON($.toJSON([]));

	for (i=0; i<locations.length; i++){
    	
    	locations[i].visited = false;
    	
    	var key = 'loc-'+locations[i].id;
    	localStorage.setItem(key,$.toJSON(locations[i]));
    	
    	locationArray[i]={location : key, topLocation : locations[i].topLocation};

		}
	
	localStorage.setItem("locArray",$.toJSON(locationArray));	
}

function loadLocations(){
	var locationArray = $.evalJSON(localStorage.getItem("locArray"));
	
	var locationsList = $("#locations").find(".locationsList");
	locationsList.empty();
	
	var topLocationsNotSet = true;
	var result = '<li data-role="list-divider" role="heading">Top locaties</li>';
	
	for (i=0; i<locationArray.length; i++){
		
		 var location = $.evalJSON(localStorage.getItem(locationArray[i].location));
		
		if(location.topLocation && topLocationsNotSet){
			result += '<li data-role="list-divider" role="heading" class="ui-li ui-li-divider ui-bar-b">Overige locaties</li>';
			topLocationsNotSet = false;
		}
		
		var id = location.id;
		var text = location.text;
		
		result += '<li id="location-'+id+'" data-corners="false" data-shadow="false" data-wrapperels="div" data-icon="arrow-r" data-iconpos="right" data-theme="c" class="ui-btn ui-btn-icon-right ui-li-has-arrow ui-li ui-li-has-count ui-li-has-thumb ui-btn-up-c">';
    	result += '<div class="ui-btn-inner ui-li">';
    	result += '<a href="#detail?id='+id+'" class="ui-link-inherit" data-transition="slide">';
    	result += '<img src="http://jquerymobile.com/test/docs/lists/images/album-bb.jpg" class="ui-li-thumb">';
    	result += '<h3 class="ui-li-heading">'+location.name+'</h3>';
    	result += '<p class="ui-li-desc">'+location.street+', '+location.city+'</p>';
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
	  $('#locationAdres').html(location.street +', '+location.city);
	  $('#locationOpen').html(location.openingstijden);
	  if(location.imageBlobKey == "")
		  $('#locationImageURL').attr("src", "_ah/img/"+location.imageBlobKey+"=s300");
	  $('#locationDescription').html(location.description);
	  $('#locationOpenSa').html(location.openingHoursSaturday);
	  $('#locationOpenSu').html(location.openingHoursSunday);
	  $('#locationInformation').html(location.info);
	  
	  if(location.wheelchairFriendly)
		  $('#locationInformation').append("<br/>Deze locatie is rolstoelvriendelijk.");
	  
	  if(location.tourAvailable)
		  $('#locationInformation').append("<br/>Op deze locatie worden rondleidingen gegeven.");
	  
	  if(location.topLocation)
		  $('#locationInformation').append("<br/>Toperrrr");
	    
	  if($('#locationInformation').html() == "")
		  $('#locationInformationLabel').hide();
	  
	  if(location.openingHoursSunday == "")
		  $('#locationOpenSuLabel').hide();
	  
  }

function updateDistances(location) {
	  var lat1 = location.coords.latitude, lon1 = location.coords.longitude;
	  console.log(lat1+" "+lon1);
	  
	  var locationArray = $.evalJSON(localStorage.getItem("locArray"));
	  //console.log(locationArray);
	  for (i=0; i<locationArray.length; i++){
		  //console.log(locationArray[i].location);
		  
		  var location = $.evalJSON(localStorage.getItem(locationArray[i].location));

		  if(location.latitude != null && location.longitude != null){
		  	  $('#location-'+location.id+' span.ui-li-count').html(calculateDistance(lat1, lon1, parseFloat(location.latitude), parseFloat(location.longitude)));
			  $('#location-'+location.id+' span.ui-li-count').show()
		  }
		  
	  }
}

  
function setMarkers() {
	//For each location put a marker on a map
	var locationArray = $.evalJSON(localStorage.getItem("locArray"));	  
	
	for (i=0; i<locationArray.length; i++){

		  var location = $.evalJSON(localStorage.getItem(locationArray[i].location));

		  if(location.latitude != null && location.longitude != null){
			  
			  setMarker(location.id, location.name, location.latitude, location.longitude, location.toplocation)
		  }
	}
}

function setVisited(id) {
	
	var location = $.evalJSON(localStorage.getItem('loc-'+id));
	location.visited = true;	
	localStorage.setItem('loc-'+id,$.toJSON(location));
}
  
  
  
function init() {
	//load data
	cacheLocations();
}
  
$(document).ready(function(e){
	init();
});