<%@ page import="com.google.appengine.api.users.*"%>
<%!UserService userService = UserServiceFactory.getUserService();%>

<div data-role="page" id="login">
	<div data-theme="a" data-role="header" data-backbtn="true">
		<h3>Inloggen</h3>
	</div>
	<div data-role="content">
		<div class="loggedIn"><p>U bent ingelogd! U kunt nu reacties plaatsen en afbeeldingen toevoegen aan locaties.</p>
		</div>
		<div class="notLoggedIn">
			<p>Als u inlogd kunt u reacties plaatsen en afbeeldingen toevoegen aan locaties. Omdat we blij zijn met uw bijdragen plaatsen we deze
				niet alleen hier maar ook op <a href="http://wikidelft.nl">WikiDelft</a>. Natuurlijk anoniem, zonder uw naam en email.</p>
		</div>
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
			updateEmail("<%=email%>");
		</script>
		<p>
			Ingelogd via Google als
			<%=email%>
		</p>
		<a rel="external" data-ajax="false" class="googleLogout" data-role="button"
			href="<%=userService.createLogoutURL("/")%>">Log
			uit</a>
		<%
			} else {
				//case 2 and 3 clientside
		%>
		<script type="text/javascript">
			updateEmail("");
		</script>
		<h4>Log in via:</h4>
			<a id="loginUrl" data-role="button" rel="external" href="<%=userService.createLoginURL("/")%>">Google</a>
		<%
			}
		%>
	</div>
</div>
