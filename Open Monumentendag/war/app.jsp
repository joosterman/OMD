<%@ page import="com.google.appengine.api.users.*"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%!UserService userService = UserServiceFactory.getUserService();%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<!--Apple Icons
<link href='*' rel='apple-touch-icon-precomposed' />
<link href='*' rel='apple-touch-startup-image' />
<link href='*' rel='icon' type='image/png' />-->
<meta content='True' name='HandheldFriendly' />
<meta name="description" content="Mobiele applicatie voor de Open Monumentendag Delft 2012" />
<meta name="keywords" content="Open Monumentendag Delft, OMD, Monumenten, Groen van Toen, informatie, applicatie, webapp, gps, mobile, mobiel, 2012 " />
<meta content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0' name='viewport' />
<meta name="apple-mobile-web-app-capable" content="yes" />
<link rel="shortcut icon" href="/favicon.ico">
<title>Open Monumentendag Delft</title>
<link rel="stylesheet" href="http://code.jquery.com/mobile/1.2.0-alpha.1/jquery.mobile-1.2.0-alpha.1.min.css" />
<!-- <link rel="stylesheet" href="http://code.jquery.com/mobile/1.2.0-alpha.1/jquery.mobile.structure-1.2.0-alpha.1.min.css"/>-->
<link rel="stylesheet" href="/stylesheets/omd2012.css" />
<link rel="stylesheet" href="/stylesheets/main.css" />
<link rel="stylesheet" href="/stylesheets/photoswipe.css" />
<!-- <link rel="stylesheet" href="/stylesheets/android2.css" type="text/css" /> -->
<script type="text/javascript" src="/scripts/modernizr.custom.js"></script>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=true"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script type="text/javascript">
	$(document).bind("mobileinit", function() {
		//$.mobile.page.prototype.options.addBackBtn = true;
		//$.mobile.page.prototype.options.domCache = true;
	});
</script>
<script type="text/javascript" src="/scripts/database.js"></script>
<script type="text/javascript" src="/scripts/scripts.js"></script>
<script type="text/javascript" src="/scripts/klass.min.js"></script>
<script src="http://code.jquery.com/mobile/1.2.0-alpha.1/jquery.mobile-1.2.0-alpha.1.min.js"></script>
<script type="text/javascript" src="/scripts/jquery.ui.map.min.js"></script>
<script type="text/javascript" src="/scripts/jquery.json-2.3.min.js"></script>
<script type="text/javascript" src="/scripts/jqm.page.params.min.js"></script>
<script type="text/javascript" src="/scripts/code.photoswipe.jquery-3.0.5.min.js"></script>
<script type="text/javascript" src="/scripts/social.js"></script>
<script type="text/javascript">
	var _gaq = _gaq || []; 
	(function() {
		var ga = document.createElement('script');
		ga.type = 'text/javascript';
		ga.async = true;
		ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
		var s = document.getElementsByTagName('script')[0];
		s.parentNode.insertBefore(ga, s);
	})();
</script>
</head>
<body onload="window.scrollTo(0,1);">
	<jsp:include page="home.jsp"></jsp:include>
	<jsp:include page="login.jsp"></jsp:include>
	<jsp:include page="map.jsp"></jsp:include>
	<jsp:include page="detail.jsp"></jsp:include>
	<jsp:include page="locations.jsp"></jsp:include>
	<jsp:include page="info.jsp"></jsp:include>
	<jsp:include page="voorwoord.jsp"></jsp:include>
	<jsp:include page="social.jsp"></jsp:include>
	<jsp:include page="thema.jsp"></jsp:include>
	<jsp:include page="wandelroutes.jsp"></jsp:include>
	<jsp:include page="routenoord.jsp"></jsp:include>
	<jsp:include page="routezuid.jsp"></jsp:include>
	<jsp:include page="messages.jsp"></jsp:include> 
	<script type="text/javascript">
		$('[data-role=page]').live('pageshow', function(event, ui) {
			try {
				_gaq.push([ '_setAccount', 'UA-33703601-1' ]);
				hash = location.hash;
				if (hash) {
					_gaq.push([ '_trackPageview', hash.substr(1) ]);
				} else {
					_gaq.push([ '_trackPageview' ]);
				}
			} catch (err) {
			}
		});
	</script>
</body>

</html>
