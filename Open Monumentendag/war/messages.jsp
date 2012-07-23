<%@page import="java.net.URL"%>
<div data-role="page" id="messages">
	<div data-theme="a" data-role="header" data-backbtn="true">
		<h3>Berichten</h3>
	</div>
	<div data-role="content">
		<div class="messages"></div>
	</div>

</div>

<!-- enable messages trough a channel -->
<script type="text/javascript" src="/_ah/channel/jsapi"></script>
<script type="text/javascript">
	var token;
	//get the channel token	
	$.getJSON("/messages", "userId="+user.userId, function(data) {
		token = data;
		var channel = new goog.appengine.Channel(data);
		var socket = channel.open();
		socket.onopen = function() {
			console.log("Message socket open.");
		};
		socket.onmessage = function(message) {
			var m = "<p>"+message.data+"</p>";
			$(".messages").append(m);
		};
		socket.onerror = function(data) {
			alert("error: "+data.description);
		};
		socket.onclose = function() {
			alert("closed");
		};
	}, function() {
		alert("failure");
	});
</script>