<%@ page import="com.google.appengine.api.users.*"%>
<%!UserService userService = UserServiceFactory.getUserService();%>

<!DOCTYPE html>
<html xmlns:fb="https://www.facebook.com/2008/fbml">
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
	href="http://code.jquery.com/mobile/1.1.1/jquery.mobile-1.1.1.min.css" />
<link rel="stylesheet" href="/stylesheets/main.css" />
<link rel="stylesheet" href="/stylesheets/photoswipe.css" />
<script type="text/javascript"
	src="http://maps.google.com/maps/api/js?sensor=true"></script>
<script src="http://code.jquery.com/jquery-1.7.1.min.js"></script>
<script type="text/javascript">
	$(document).bind("mobileinit", function() {
		$.mobile.page.prototype.options.addBackBtn = true;
	});
</script>
<script src="/scripts/database.js"></script>
<script src="/scripts/scripts.js"></script>
<script type="text/javascript" src="/scripts/klass.min.js"></script>
<script
	src="http://code.jquery.com/mobile/1.1.1/jquery.mobile-1.1.1.min.js"></script>
<script type="text/javascript" src="/scripts/jquery.ui.map.js"></script>
<script type="text/javascript" src="/scripts/jquery.json-2.3.min.js"></script>
<script type="text/javascript" src="/scripts/jqm.page.params.js"></script>
<script type="text/javascript" src="/scripts/code.photoswipe.jquery-3.0.5.min.js"></script>
<script type="text/javascript" src="/scripts/social.js"></script>
</head>
<body onload="window.scrollTo(0,1);">
	<!-- BEGIN Facebook stuff -->
	<div id="fb-root"></div>
	<script>
		window.fbAsyncInit = function() {
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
				if (response.status === "connected") {
					fbLoggedIn(true);
				} else {
					fbLoggedIn(false);
				}
			});

			$(".fbLogout").click(function() {
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

		function fbLoggedIn(status) {
			if (status === true) {
				FB.api('/me', function(user) {
					$(".fbemail").html(user.email);
				});
				$(".fbLoggedIn").show();
				$(".notLoggedIn").hide();
			} else {
				$(".fbLoggedIn").hide();
				$(".notLoggedIn").show();
			}
		}
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
	<jsp:include page="messages.jsp"></jsp:include>
</body>

</html>