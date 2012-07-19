var tracking = 0
$(document).ready(function() {
	$('.measure').mouseup(function(e) {
		if (tracking === 0) {
			var offset = $(this).offset();
			var x = e.pageX - offset.left;
			var y = e.pageY - offset.top;
			$('#cropLeftX').val(x);
			$('#cropTopY').val(y);
			tracking = 1;
		}
		else{
			var offset = $(this).offset();
			var x = e.pageX - offset.left;
			var y = e.pageY - offset.top;
			$('#cropRightX').val(x);
			$('#cropBottomY').val(y);
			tracking = 0;
		}
	});
});
