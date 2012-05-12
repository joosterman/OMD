<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Open Monumentendag Delft</title>
<link rel="stylesheet" href="http://code.jquery.com/mobile/1.1.0/jquery.mobile-1.1.0.min.css" />
<link rel="stylesheet" href="/stylesheets/main.css" />
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true" ></script>
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="/scripts/scripts.js"></script>
<script type="text/javascript" src="http://code.jquery.com/mobile/latest/jquery.mobile.min.js"></script>
<script type="text/javascript" src="/scripts/jquery.ui.map.js"></script>
<script src="/scripts/jqm.page.params.js"></script>

</head>
<body>
	<div data-role="page" id="home">
		<jsp:include page="home.jsp"></jsp:include>
	</div>
	<div data-role="page" id="map">
		<jsp:include page="map.jsp"></jsp:include>
	</div>
	<div data-role="page" id="detail">
		<jsp:include page="detail.jsp"></jsp:include>
	</div>
	<div data-role="page" id="locations">
		<jsp:include page="locations.jsp"></jsp:include>
	</div>
	<div data-role="page" id="info">
		<jsp:include page="info.jsp"></jsp:include>
	</div>
</body>
</html>