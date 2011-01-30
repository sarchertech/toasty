function isTmaxLocal() {
};

function activateBed(form) {
  var form = form;
  var url = "http://localhost:4567/1/";
	var bed = $("#tan_session_bed_id").val();
	var minutes = $("#tan_session_minutes").val();
	var delay = $("#tan_session_delay").val();
	$.ajax({
	  url: url + bed + "/" + minutes + "/" + delay,
	  success: function() {
	    //alert('bed ' + bed + ' activated');
	    //getTimeStatus(6);
	  },
	  error: function(xhr, ajaxOptions, thrownError){
	    alert('bed not activated--' + thrownError );
	  }
	});
};

function resetBed() {
  var url = "http://localhost:4567/3/";
  var bed = $("#tan_session_bed_id").val();
  $.ajax({
    url: url + bed,
    success: function() {
      //getTimeStatus(6);
    },
    error: function(xhr, ajaxOptions, throwError){
      alert('bed not reset--' + thrownError );
    }
  });
};

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
    var countdown_span = $("#_" + val.number + " .countdown");
    var status_span = $("#_" + val.number + " .level_and_status");
    
    if (val.status == 1) {
      status_span.html("Delay");
    }
    else if (val.status == 5) {
      status_span.html("Cooling");
    }
    else if (val.status == 3) {
      status_span.html("Running");
    }
    else {
      status_span.html("Level " +status_span.attr("data-bed-level")); 
    };
    
    if (val.time) {
      countdown_span.html(minutes(val.time)).attr("data-time-seconds", val.time);
    }
    else {
      countdown_span.attr("data-time-seconds", 0).html("");
    };
  });
};

function minutes(seconds) {
  var minutes = Math.floor(seconds/60);
  var seconds = seconds % 60;
  seconds = ( seconds < 10 ? "0" : "" ) + seconds
  return minutes + ":" + seconds;
};

function ticker() {
  //$("#dash_buttons .countdown").html(minutes($("#dash_buttons .countdown").attr("data-time-seconds") - 1))
  $("#dash_buttons .countdown").each(function(i, val) {
    var seconds = $(val).attr("data-time-seconds");
    if (seconds > 0) {
      $(val).html(minutes(seconds -1)).attr("data-time-seconds", seconds -1);
    };
  });
};

$(document).ready(function() {
  $("#new_tan_session").submit(function() {
    activateBed($(this));
    return false;
  });

	$("#dash_buttons a").click(function() {
		var num = $(this).attr("data-bed")
		$("#dash_start h2 span").html(num);
		$("#tan_session_bed_id").val(num);
		return false;
	});
	
	$("#reset").click(function() {
	  resetBed();
	  return false;
	});
	
	getTimeStatus(6);
	
	window.setInterval(function() {
	  getTimeStatus(6);
  }, 1000);
	
	//window.setInterval(function() {
	  //getTimeStatus(14);
	  //ticker();
  //}, 1000);
});
