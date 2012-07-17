<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<!--Apple Icons
<link href='*' rel='apple-touch-icon-precomposed' />
<link href='*' rel='apple-touch-startup-image' />
<link href='*' rel='icon' type='image/png' />-->
<meta content='True' name='HandheldFriendly' />
<meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0' name='viewport' />
<title>Open Monumentendag Delft</title>
<link rel="stylesheet" href="http://code.jquery.com/mobile/1.1.1/jquery.mobile-1.1.1.min.css" />
<link rel="stylesheet" href="/stylesheets/main.css" />
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true" ></script>
<script src="http://code.jquery.com/jquery-1.7.1.min.js"></script>
<script type="text/javascript">
    $(document).bind("mobileinit", function(){
        $.mobile.page.prototype.options.addBackBtn= true;
    });
</script>
<script src="/scripts/database.js"></script>
<script src="/scripts/scripts.js"></script>
<script src="http://code.jquery.com/mobile/1.1.1/jquery.mobile-1.1.1.min.js"></script>
<script type="text/javascript" src="/scripts/jquery.ui.map.js"></script>
<script type="text/javascript" src="/scripts/jquery.json-2.3.min.js"></script>
<script type="text/javascript" src="/scripts/jqm.page.params.js"></script>
<script type="text/javascript" src="/scripts/social.js"></script>





</head>
<body onload="window.scrollTo(0,1);">
	<jsp:include page="home.jsp"></jsp:include>
	<jsp:include page="map.jsp"></jsp:include>
	<jsp:include page="detail.jsp"></jsp:include>
	<jsp:include page="locations.jsp"></jsp:include>
	<jsp:include page="info.jsp"></jsp:include>
	<jsp:include page="social.jsp"></jsp:include>
	<jsp:include page="thema.jsp"></jsp:include>
</body>
</html>