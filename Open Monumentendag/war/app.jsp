<%@ page import="com.google.appengine.api.users.*"%>
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
<meta
	content='width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0'
	name='viewport' />
<meta name="apple-mobile-web-app-capable" content="yes" />
<title>Open Monumentendag Delft</title>
<link rel="stylesheet"
	href="http://jquerymobile.com/test/css/themes/default/jquery.mobile.css" />
<link rel="stylesheet" href="/stylesheets/main.css" />
<link rel="stylesheet" href="/stylesheets/photoswipe.css" />
<link rel="stylesheet" href="/stylesheets/android2.css" type="text/css" />
<script type="text/javascript"
	src="http://maps.google.com/maps/api/js?sensor=true"></script>
<script src="http://jquerymobile.com/test/js/jquery.js"></script>
<script type="text/javascript">
	$(document).bind("mobileinit", function() {
		$.mobile.page.prototype.options.addBackBtn = true;
	});
</script>
<!--<script type="text/javascript" src="/_ah/channel/jsapi"></script> -->
<script src="/scripts/database.js"></script>
<script src="/scripts/scripts.js"></script>
<script type="text/javascript" src="/scripts/klass.min.js"></script>
<script
	src="http://jquerymobile.com/test/js/jquery.mobile.js"></script>
<script type="text/javascript" src="/scripts/jquery.ui.map.js"></script>
<script type="text/javascript" src="/scripts/jquery.json-2.3.min.js"></script>
<script type="text/javascript" src="/scripts/jqm.page.params.js"></script>
<script type="text/javascript" src="/scripts/code.photoswipe.jquery-3.0.5.min.js"></script>
<script type="text/javascript" src="/scripts/social.js"></script>
<script type="text/javascript">
	var _gaq = _gaq || [];

	(function() {
		var ga = document.createElement('script');
		ga.type = 'text/javascript';
		ga.async = true;
		ga.src = ('https:' == document.location.protocol ? 'https://ssl'
				: 'http://www')
				+ '.google-analytics.com/ga.js';
		var s = document.getElementsByTagName('script')[0];
		s.parentNode.insertBefore(ga, s);
	})();
</script>
</head>
<body onload="window.scrollTo(0,1);">
	<!-- BEGIN Facebook stuff -->
	<div id="fb-root"></div>
	<script>
		window.fbAsyncInit = function() {
			//disable facebook of not allowed on host (localhost for example)
			fbLoggedIn(false);
			//Init FB
			FB
					.init({
						appId : '470201716343067', // App ID
						channelUrl : 'http://openmonumentendag.appspot.com//channel.html', // Channel File
						status : true, // check login status
						cookie : true, // enable cookies to allow the server to access the session
						xfbml : true
					// parse XFBML
					});
			// Additional initialization code here
			FB.Event.subscribe('auth.statusChange', function(response) {
				console.debug(response);
				if (response.status === "connected") {
					updateFBAccessToken(response.authResponse.accessToken);
					fbLoggedIn(true);
				} else {
					fbLoggedIn(false);
				}
			});

			$(".fbLogout").click(function() {
				updateEmail("");
				user.fbAccessToken = "";
				FB.logout();
			});
		};
		// Load the SDK Asynchronously
		(function(d) {
			var js, id = 'facebook-jssdk', ref = d
					.getElementsByTagName('script')[0];
			if (d.getElementById(id)) {
				return;
			}
			js = d.createElement('script');
			js.id = id;
			js.async = true;
			js.src = "//connect.facebook.net/en_US/all.js";
			ref.parentNode.insertBefore(js, ref);
		}(document));
	</script>
	<!-- END Facebook stuff -->
	<jsp:include page="home.jsp"></jsp:include>
	<jsp:include page="map.jsp"></jsp:include>
	<jsp:include page="detail.jsp"></jsp:include>
	<jsp:include page="locations.jsp"></jsp:include>
	<jsp:include page="info.jsp"></jsp:include>
	<jsp:include page="social.jsp"></jsp:include>
	<jsp:include page="thema.jsp"></jsp:include>
	<jsp:include page="login.jsp"></jsp:include>
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
