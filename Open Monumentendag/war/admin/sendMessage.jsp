<%@ page import="com.google.appengine.api.channel.*"%>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.googlecode.objectify.*" %>
<%@ page import="org.omd.User" %>

<%
//get the message
String message = request.getParameter("message");
//encode the message as JSON
Gson gson = new Gson();
message = gson.toJson(message);
//get all users to send the message to
Objectify ofy = ObjectifyService.begin();
//get the channelservice
ChannelService channelService = ChannelServiceFactory.getChannelService();
//send the message to each user
for(User u: ofy.query(User.class)){
	channelService.sendMessage(new ChannelMessage(u.id.toString(), message));
}
%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="./stylesheets/admin.css" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">
</script>
</head>
<body>
<form action="" method="get">
<input type="text" name="message" /><br />
<input type="submit" value="Verstuur" class="sendMessage" />
</form>
</body>
</html>
