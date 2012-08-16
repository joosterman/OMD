<%@ page contentType="text/html; charset=UTF-8" %>
<%@page import="org.omd.Message"%>
<%@page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.channel.*"%>
<%@ page import="com.google.gson.Gson"%>
<%@ page import="com.googlecode.objectify.*"%>
<%@ page import="org.omd.User"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*" %>
<%!
Gson gson = new Gson();
Objectify ofy = ObjectifyService.begin();
ChannelService channelService = ChannelServiceFactory.getChannelService();
UserService userService = UserServiceFactory.getUserService();
DateFormat dformat = DateFormat.getDateTimeInstance(DateFormat.SHORT,DateFormat.SHORT);
%>

<%
	//get the message
	String message = request.getParameter("message");
	if(message !=null && !message.trim().equals("")){
		String author = request.getParameter("author");
		String validUntil = request.getParameter("validUntil");
		String importance = request.getParameter("importance");
		Message m = new Message();
		m.author = author;
		m.validUntil = dformat.parse(validUntil);
		m.importance = importance;
		m.dateCreated = new Date();
		
		String json= gson.toJson(m);
		for (User u : ofy.query(User.class)) {
			channelService.sendMessage(new ChannelMessage(u.id.toString(), json));
		}	
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="./stylesheets/admin.css" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript"
	src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="
	
xt/javascript">
</script>
</head>
<body>
	<form action="" method="post">
		<table>
			<tr>
				<td>Auteur</td>
				<td><input type="text" name="author"
					value="<%=userService.getCurrentUser().getNickname()%>" /></td>
			</tr>
			<tr>
				<td>Bericht</td>
				<td><textarea name="message"></textarea></td>
			</tr>
			<tr>
				<td>Geldig tot</td>
				<td><input type="datetime" name="validUntil" value="<%=dformat.format(new Date())%>" /></td>
			</tr>
			<tr>
				<td>Belangrijk</td>
				<td>laag:<input type="radio" name="importance" value="low" />normaal:<input
					type="radio" name="importance" value="normal" checked="checked"/>hoog:<input
					type="radio" name="importance" value="high" />
				</td>
			</tr>
			<tr>
				<td></td>
				<td><input type="submit" value="Verstuur" class="sendMessage" /></td>
			</tr>
		</table>
	</form>
</body>
</html>
