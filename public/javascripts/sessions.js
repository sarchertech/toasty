function isTmaxLocal() {
}

function getTimeStatus(beds) {
	var url = "http://localhost:4567/2/"
	$.ajax({
	  url: url + beds,
	  dataType: 'json',
	  success: function(json) {
	    applyTimeStatus(json);
	  },
	  error: function(xhr, ajaxOptions, thrownError){
	    alert('status and times error--' + thrownError);
	  }
	});
};

function applyTimeStatus(json) {
  $.each(json, function(i, val) {
    $("#_" + val.number).removeClass().addClass("_" + val.status);
    if (val.time) {
      $("#_" + val.number + " .countdown").html(minutes(val.time));
    };
  });
};

function minutes(seconds) {
  var minutes = Math.floor(seconds/60);
  var seconds = seconds % 60;
  seconds = ( seconds < 10 ? "0" : "" ) + seconds
  return minutes + ":" + seconds;
};

$(document).ready(function() {
  $("#new_tan_session").submit(function() {
    var form = $(this)
    var url = "http://localhost:4567/1/"
		var bed = $("#tan_session_bed_id").val();
		var minutes = $("#tan_session_minutes").val();
		var delay = $("#tan_session_delay").val();
		//$.get(url + bed + "/" + minutes + "/" + delay);
		$.ajax({
		  url: url + bed + "/" + minutes + "/" + delay,
		  success: function() {
		    alert('bed ' + bed + ' activated');
		  },
		  error: function(xhr, ajaxOptions, thrownError){
		    alert('bed not activated--' + thrownError );
		  }
		});
    return false;
  });

	$("#dash_buttons a").click(function() {
		var num = $(this).attr("data-bed")
		$("#dash_start h2 span").html(num);
		$("#tan_session_bed_id").val(num);
		return false;
	});
	
	getTimeStatus(14);
});
