function setVisited(id) {
	
	var location = $.evalJSON(localStorage.getItem('loc-'+id));
	location.visited = true;	
	localStorage.setItem('loc-'+id,$.toJSON(location));
}


function loadLocations(){
	var jsonObj = $.getJSON("/data", 
			{}
			,parseLocations
	);
}

function parseLocations(locations){
	var locationsList = $("#locations").find(".locationsList");
	locationsList.empty();
	
	var topLocationsNotSet = true;
	var result = '<li data-role="list-divider" role="heading">Top locaties</li>';
	
	for (i=0; i<locations.length; i++){
		
		if(locations[i].topLocation && topLocationsNotSet){
			result += '<li data-role="list-divider" role="heading" class="ui-li ui-li-divider ui-bar-b">Overige locaties</li>';
			topLocationsNotSet = false;
		}
		
		var id = locations[i].id;
		var text = locations[i].text;
		
		result += '<li id="tweet-'+id+'" data-corners="false" data-shadow="false" data-wrapperels="div" data-icon="arrow-r" data-iconpos="right" data-theme="c" class="ui-btn ui-btn-icon-right ui-li-has-arrow ui-li ui-li-has-count ui-li-has-thumb ui-btn-up-c">';
    	result += '<div class="ui-btn-inner ui-li">';
    	result += '<a href="#detail?id='+id+'" class="ui-link-inherit" data-transition="slide">';
    	result += '<img src="#data?id='+id+'" class="ui-li-thumb">';
    	result += '<h3 class="ui-li-heading">'+locations[i].name+'</h3>';
    	result += '<p class="ui-li-desc">'+locations[i].street+', '+locations[i].city+'</p>';
    	result += '</a>';
    	result += '<span class="ui-icon ui-icon-arrow-r ui-icon-shadow">&nbsp;</span>';
    	result += '</div">';
    	result += '</li>';
    	
    	locations[i].visited = false;
    	
    	localStorage.setItem('loc-'+id,$.toJSON(locations[i]));

		}
	
	locationsList.append(result);
	locationsList.listview("refresh");
	
}
  

  
  function loadLocation(id) {
	  var location = $.evalJSON(localStorage.getItem('loc-'+id));
	  
	  $('.locationName').html(location.name);
	  $('#locationAdres').html(location.street +', '+location.city);
	  $('#locationOpen').html(location.openingstijden);
	  $('#locationImageURL').attr("src", "img/"+id+"_288.jpg");
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
	  
	  //"topLocation":false,"wheelchairFriendly":true,"tourAvailable":true,"city":"Delft","street":"Bagijnhof 21"},
  }
  
  function updateDistances(tx, rs) {
	  
	  var lat1 = Number(sessionStorage.getItem("lat")), lon1 = Number(sessionStorage.getItem("lon"));
	  console.debug(lat1+" "+lon1);	  
	  
	  for (var i=0; i < rs.rows.length; i++) {
		  console.debug(rs.rows.item(i).latitude+" "+rs.rows.item(i).longitude);
		  $('#location-'+rs.rows.item(i).id+' span.ui-li-count').html(calculateDistance(lat1, lon1, rs.rows.item(i).latitude, rs.rows.item(i).longitude));
		  $('#location-'+rs.rows.item(i).id+' span.ui-li-count').show();
	  }
  }
  
function setMarkers(tx, rs) {
	  
	  for (var i=0; i < rs.rows.length; i++) {
		  setMarker(rs.rows.item(i).id, rs.rows.item(i).title, rs.rows.item(i).latitude, rs.rows.item(i).longitude, rs.rows.item(i).toplocation)
	  }
  }
  
  
  
  function init() {
	  //load data
  }
  
  $(document).ready(function(e){
	init();
  });