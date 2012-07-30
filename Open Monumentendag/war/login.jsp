<%@ page import="com.google.appengine.api.users.*"%>
<%!UserService userService = UserServiceFactory.getUserService();%>

<div data-role="page" id="login">
	<div data-theme="a" data-role="header" data-backbtn="true">
		<h3>Inloggen</h3>
	</div>
	<div data-role="content">
		<%
			//case 1: not logged in: show google and FB buttons
			//case 2: logged in with google: show loggedin email and logout link
			//case 3: logged in with FB: show loggedin email and logout link

			//case 1: Google (server-side)
			if (userService.isUserLoggedIn()) {
				User u = userService.getCurrentUser();
				String email = u.getEmail();
		%>
		<script type="text/javascript">
		console.log("Updating google email");
		updateEmail('<%=email%>
			');
		</script>
		<p>

			Ingelogd via Google als
			<%=email%>
		</p>
		<a rel="external" class="googleLogout" data-role="button"
			href="<%=userService.createLogoutURL(request.getRequestURI())%>">Log
			uit</a>
		<%
			} else {
				//case 2 and 3 clientside
		%>
		<div class="fbLoggedIn">
			<p>
				Ingelogd via Facebook als <span class="fbemail"></span>
			</p>
			<a class="fbLogout" href="" data-role="button">Log uit</a>
		</div>
		<div class="notLoggedIn">
			<h4>Log in via</h4>
			<a href="<%=userService.createLoginURL(request.getRequestURI())%>"><img
				src="./img/google.png" alt="Google logo" /></a> of
			<div class="fb-login-button" data-show-faces="false"
				data-scope="email" data-width="200" data-max-rows="1"></div>
		</div>
		<%
			}
		%>
	</div>
</div>
