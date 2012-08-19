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
	var tweetsList = $("#tweets").find(".tweetsList");
	tweetsList.empty();
	
	var result = '';
	for (i=0; i<tweets.results.length; i++){
		
		var id = tweets.results[i].id;
		var text = tweets.results[i].text;
		/*var text = tweets.results[i].text.replace('@(https?://([-\w\.]+)+(/([\w/_\.]*(\?\S+)?(#\S+)?)?)?)@', '<a href="$1">$1</a>') //turn URLs into links
		.replace('/@(\w+)/', '<a href="http://twitter.com/$1">@$1</a>'); //turn twitter usernames into links*/
		
		result += '<li id="tweet-'+id+'">';
		result += '<a href="https://mobile.twitter.com/'+tweets.results[i].from_user+'/status/'+tweets.results[i].id_str+'" class="ui-link-inherit" data-transition="slide">';
		//result += '<img src="'+tweets.results[i].profile_image_url+'">';
		result += '<h3>@'+tweets.results[i].from_user+'</h3>';
		result += '<p>'+text+'</p>';
		result += '<p></p>';
		result += '<p class="ui-li-aside"><strong>'+tweets.results[i].created_at+'</strong>PM</p>';
		result += '</a>';
		result += '</li>';
		/*
    	result += '<h3 class="ui-li-heading">'+text+'</h3>';
    	result += '<p class="ui-li-desc">@'+tweets.results[i].from_user+'</p>';
    	result += '<p class="ui-li-desc">'+tweets.results[i].created_at+'</p>';
    	result += '</a>';
    	result += '<span class="ui-icon ui-icon-arrow-r ui-icon-shadow">&nbsp;</span>';
    	result += '</div">';
    	result += '</li>';*/

		}
	
	tweetsList.append(result);
	tweetsList.listview("refresh");
	
	//console.log($('<div>').append($('#tweets').clone()).html());
	
}