<%@ page import="com.google.appengine.api.users.*"%>
<%!UserService userService = UserServiceFactory.getUserService();%>

<div data-role="page" id="login">
	<div data-theme="a" data-role="header" data-backbtn="true">
		<h3>Inloggen</h3>
	</div>
	<div data-role="content">
		<h4>Log direct in met</h4>
		<p>
			Google:
			<%
			//check google login
			if (userService.isUserLoggedIn()) {
				User u = userService.getCurrentUser();
		%>
			Ingelogd als
			<%=u.getEmail()%>
			<%
				if (userService.isUserAdmin()) {
			%>(admin) 
			<%
				}
			%>
			 <a rel="external" class="fineprint"
				href="<%=userService.createLogoutURL(request.getRequestURI())%>">logout</a>
			<%
				}
				else {
			%>
			<a rel="external" href="<%=userService.createLoginURL(request.getRequestURI())%>"><img
				src="./img/google.png" alt="Google icon" /></a> Niet ingelogd
			<%
				}
			%>
		</p>
		<p>
			Facebook:
			<span class="fbLogin">
			<fb:login-button scope="email" show-faces="false" /></span>
			<span class="fbLoginStatus"></span><a class="fbLogout fineprint"
				href="#login">logout</a>
		</p>
	</div>
</div>
