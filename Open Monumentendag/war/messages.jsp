<%@page import="java.net.URL"%>
<div data-role="page" id="messages">
	<div data-theme="a" data-role="header" data-backbtn="true">
		<h3>Berichten</h3>
	</div>
	<div data-role="content">
	<input type="text" class="message" />
	<input class="sendMessage" type="button" value="Submit message" />
	</div>

</div>

<!-- enable messages trough a channel -->
<script type="text/javascript" src="/_ah/channel/jsapi"></script>
<script type="text/javascript">
	var token;
	var userId = Math.random();
	$(".sendMessage").click(function(){
		var m = $(".message").val();
		$.ajax("/messages?userId="+userId+"&message="+m);
	});

	//get the channel token
	
	$.getJSON("/messages", "userId="+userId, function(data) {
		token = data;
		var channel = new goog.appengine.Channel(data);
		var socket = channel.open();
		socket.onopen = function() {
		};
		socket.onmessage = function(message) {
			alert(message.data);
		};
		socket.onerror = function() {
			alert("error");
		};
		socket.onclose = function() {
			alert("close");
		};
	}, function() {
		alert("failure");
	});
</script>