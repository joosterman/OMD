  var ziedelft = {};
  ziedelft.webdb = {};
  ziedelft.webdb.db = null;
  
  ziedelft.webdb.open = function() {
	var dbSize = 5 * 1024 * 1024; // 5MB
	ziedelft.webdb.db = openDatabase("ZieDelft", "1.0", "ZieDelft Database", dbSize);
  }
  
  ziedelft.webdb.createTable = function() {
	var db = ziedelft.webdb.db;	
	
	db.transaction(function(tx) {
		//Create the database for the punches
		tx.executeSql(
			"CREATE TABLE IF NOT EXISTS locations(" +
			" id INTEGER PRIMARY KEY ASC," +
			" name TEXT," + 
			" adres TEXT," +
			" openingstijden TEXT," +
			" beschrijving TEXT," +
			" imageURL TEXT," +
			" latitude DECIMAL(2,7)," +
			" longitude DECIMAL(2,7)," +
			" toplocation INTEGER," +
			" visited INTEGER," +
			" last_modified DATETIME);", []);
	});
	
	db.transaction(function(tx) {
		//Insert item
		tx.executeSql(
			"INSERT OR REPLACE INTO locations" +
			" (id, name, adres, openingstijden, latitude, longitude, visited, toplocation, last_modified, beschrijving)" +
			" VALUES (3, 'Het meisjeshuis', 'Verreweg 1 Delft', '9:00 - 17.00', 52.010903, 4.356808, 0, 1, strftime('%s', 'now'), 'Allemaal leuke dingen!');", []);
	});
	db.transaction(function(tx) {
		//Insert item
		tx.executeSql(
			"INSERT OR REPLACE INTO locations" +
			" (id, name, adres, openingstijden, latitude, longitude, visited, toplocation, last_modified, beschrijving)" +
			" VALUES (4, 'Prinsenhof', 'Verreweg 113 Delft', '9:00 - 17.00', 52.011667, 4.354444, 1, 0, strftime('%s', 'now'), 'Allemaal leuke dingen!');", []);
	});
  }
  /* Add functions */
  ziedelft.webdb.setVisited = function(id) {

	var db = ziedelft.webdb.db;
	db.transaction(function(tx){
	  
	  tx.executeSql("UPDATE locations SET visited = 1 WHERE id = ?;",
		  [id],
		  ziedelft.webdb.onSuccess,
		  ziedelft.webdb.onError);
	 });
  }
  
  ziedelft.webdb.onError = function(tx, e) {
	alert("There has been an error: " + e.message);
  }
  
  ziedelft.webdb.onSuccess = function(tx, r) {
	// re-render the data.
	ziedelft.webdb.getAllLocations(loadLocations);
  }
  
  /* Get functions */  
  ziedelft.webdb.getAllLocations = function(renderFunc) {
	var db = ziedelft.webdb.db;
	db.transaction(function(tx) {
	  tx.executeSql("SELECT * FROM locations", [], renderFunc,
		  ziedelft.webdb.onError);
	});
  }
  
  ziedelft.webdb.getLocation = function(renderFunc, id) {
	var db = ziedelft.webdb.db;
	db.transaction(function(tx) {
	  tx.executeSql("SELECT * FROM locations WHERE id = ?;", 
		  [id],
		  renderFunc,
		  ziedelft.webdb.onError);
	});
  }
  
  function loadLocations(tx, rs) {
	var topLocationsNotSet = true;
	var rowOutput = '<li data-role="list-divider" role="heading">Top locaties</li>';
	var locationsList = $("#locations").find(".locationsList");
	locationsList.empty();
	
	for (var i=0; i < rs.rows.length; i++) {
		if(rs.rows.item(i).toplocation == 0 && topLocationsNotSet){
			rowOutput += '<li data-role="list-divider" role="heading">Overige locaties</li>';
			topLocationsNotSet = false;
		}
	  rowOutput += renderLocations(rs.rows.item(i));
	}  
	locationsList.append(rowOutput);
	locationsList.listview("refresh");
  }
  
  function loadLocation(tx, rs) {
	  $('.locationName').html(rs.rows.item(0).name);
	  $('#locationAdres').html(rs.rows.item(0).adres);
	  $('#locationOpen').html(rs.rows.item(0).openingstijden);
	  $('#locationImageURL').attr("src", "img/"+rs.rows.item(0).id+"_288.jpg");
	  $('#locationDescription').html(rs.rows.item(0).beschrijving);
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
  
  
  
  /*Render functions*/
  function renderLocations(row) {
    var result = '<li id="location-'+row.id+'" data-corners="false" data-shadow="false" data-wrapperels="div" data-icon="arrow-r" data-iconpos="right" data-theme="c" class="ui-btn ui-btn-icon-right ui-li-has-arrow ui-li ui-li-has-count ui-li-has-thumb ui-btn-up-c">';
    	result += '<div class="ui-btn-inner ui-li">';
    	result += '<a href="#detail?id='+row.id+'" class="ui-link-inherit" data-transition="slide">';
    	result += '<img src="img/'+row.id+'_80.jpg" class="ui-li-thumb">';
    	result += '<h3 class="ui-li-heading">'+row.name+'</h3>';
    	result += '<p class="ui-li-desc">'+row.adres+'</p>';
    	result += '<span class="ui-li-count ui-btn-up-c ui-btn-corner-all" style="display: none;"></span>';
    	result += '</a>';
    	result += '<span class="ui-icon ui-icon-arrow-r ui-icon-shadow">&nbsp;</span>';
    	result += '</div">';
    	result += '</li>';
	return  result;
  }
  
  
  
  function init() {
	ziedelft.webdb.open();
	ziedelft.webdb.createTable();
  }
  
  $(document).ready(function(e){
	init();
  });