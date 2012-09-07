function loadTweets(query){
	var jsonObj = $.getJSON("http://search.twitter.com/search.json?callback=?", 
			{
				q: query,
				rpp: 40
			}
			,parseTweets
	);
}

function parseTweets(tweets){
	$('#jstwitter').empty();
	var html = '<div class="tweet"><!--<img style="float:left; border: 1px solid; overflow:hidden;" src="PROFILE_PIC" />--><span class="text">TWEET_TEXT</span><span class="time">AGO</span> by <span class="user">USER</span></div>';
    

    var data = tweets['results'];

    // append tweets into page
    for (var i = 0; i < data.length; i++) {

        $('#jstwitter').append( 
            html.replace('TWEET_TEXT', clean(data[i].text) )
                .replace(/USER/g, '<a target="_blank" href="http://twitter.com/intent/user?screen_name=' + data[i].from_user + '">@' + data[i].from_user + '</a>')
                .replace('AGO', timeAgo(data[i].created_at))
                //.replace('PROFILE_PIC',data[i].profile_image_url)
        );
    }          
}

function link(tweet) {
      return tweet.replace(/\b(((https*\:\/\/)|www\.)[^\"\']+?)(([!?,.\)]+)?(\s|$))/g, function(link, m1, m2, m3, m4) {
        var http = m2.match(/w/) ? 'http://' : '';
        return '<a class="twtr-hyperlink" target="_blank" href="' + http + m1 + '">' + ((m1.length > 25) ? m1.substr(0, 24) + '...' : m1) + '</a>' + m4;
      });
}

function at(tweet) {
      return tweet.replace(/\B[@＠]([a-zA-Z0-9_]{1,20})/g, function(m, username) {
        return '<a target="_blank" class="twtr-atreply" href="http://twitter.com/intent/user?screen_name=' + username + '">@' + username + '</a>';
      });
}


function list(tweet){
      return tweet.replace(/\B[@＠]([a-zA-Z0-9_]{1,20}\/\w+)/g, function(m, userlist) {
        return '<a target="_blank" class="twtr-atreply" href="http://twitter.com/' + userlist + '">@' + userlist + '</a>';
      });
}

function hashm(tweet) {
      return tweet.replace(/(^|\s+)#(\w+)/gi, function(m, before, hash) {
        return before + '<a target="_blank" class="twtr-hashtag" href="http://twitter.com/search?q=%23' + hash + '">#' + hash + '</a>';
      });
}

function clean(tweet) {
    	return hashm(at(list(link(tweet))));
}


function timeAgo(dateString) {
    var rightNow = new Date();
    var then = new Date(dateString);
     
    if ($.browser.msie) {
        // IE can't parse these crazy Ruby dates
        then = Date.parse(dateString.replace(/( \+)/, ' UTC$1'));
    }

    var diff = rightNow - then;

    var second = 1000,
    minute = second * 60,
    hour = minute * 60,
    day = hour * 24,
    week = day * 7;

    if (isNaN(diff) || diff < 0) {
        return ""; // return blank string if unknown
    }

    if (diff < second * 2) {
        // within 2 seconds
        return "right now";
    }

    if (diff < minute) {
        return Math.floor(diff / second) + " seconds ago";
    }

    if (diff < minute * 2) {
        return "about 1 minute ago";
    }

    if (diff < hour) {
        return Math.floor(diff / minute) + " minutes ago";
    }

    if (diff < hour * 2) {
        return "about 1 hour ago";
    }

    if (diff < day) {
        return  Math.floor(diff / hour) + " hours ago";
    }

    if (diff > day && diff < day * 2) {
        return "yesterday";
    }

    if (diff < day * 365) {
        return Math.floor(diff / day) + " days ago";
    }

    else {
        return "over a year ago";
    }
}