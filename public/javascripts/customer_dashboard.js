function activateBed() {
  var form = $("#new_tan_session");
  var url = $activate_url;
	var bed = $("#tan_session_bed_id").val();
	var minutes = $("#tan_session_minutes").val();
	var delay = 6;
	$.ajax({
	  url: url + bed + "/" + minutes + "/" + delay,
	  success: function() {
  	  var num = $("#dash_start h2 span").html();
  	  var a = $("#_" + num + " a")
  	  $("#post_active").html("Bed " + num + " Will Activate <br /> in 6 Minutes");
  	  $("#dash_controls_wrapper").hide(0, function() {
  	    $("#post_active").fadeIn(1000);
  	  });
	  },
	  error: function(xhr, ajaxOptions, thrownError){
	    $sent = false
	    alert('bed not activated--' + thrownError );
	  }
	});

	$("#_" + bed).removeClass().addClass("_1");

  $("#_" + bed).attr("data-bed-loading", "1");
	$("#bed_activated p").html("Bed " + bed + " Activated");
	$("#bed_activated").fadeIn().delay(300).fadeOut('slow');
};

function getTimeStatus(beds) {
	var url = $status_url;
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
    var l = $("#_" + val.number)
    if (l.attr("data-bed-loading") == "0") {
      l.removeClass().addClass("_" + val.status);
    }
  });
};

function selectBed(a) {
	var num = a.attr("data-bed");
	var max = a.attr("data-maxtime");
	var level = a.children(".level_and_status").attr("data-bed-level")
	$("#dash_buttons a").removeClass("bed_active");
	a.addClass("bed_active");
	$("#dash_start h2 span").html(num);
	$("#tan_session_bed_id").val(num);
	$time_box.attr("data-maxtime", max);
	$("#max_time").html("Max Time " + max + " Minutes");
	$("#bed_level").html("Level " + level + " Bed")
	if(+$time_box.val() > max ) {
		$time_box.val(max);
	};
	return false;
};

$(document).ready(function() {
  $ip = "localhost"
  $activate_url = "http://" + $ip + ":4567/1/";
  $status_url = "http://" + $ip + ":4567/2/";
  $number_of_beds = 15
  $index = $("#tan_session_minutes");
  $time_box = $("#tan_session_minutes");
  $sent = false
  
  $("body").click(function() {
    return false;
  });
  
  $("body").mousedown(function() {
    return false;
  });
  
  $(document)[0].oncontextmenu = function() {return false;}
  
  $("#dash_up_arrow").mousehold(function(){
    max = $index.attr("data-maxtime")
    if(+$index.val() < max) {
  		$index.val(+$index.val()+1 );
  	}
  });

  $("#dash_down_arrow").mousehold(function(){
  	if(+$index.val() > 2) {
  		$index.val( +$index.val()-1 );
  	}
  });
  
  $("#start_admin").click(function() {
    activateBed($(this));
    return false;
  });
  
  $("#new_tan_session").submit(function() {
    activateBed($(this));
    return false;
  });
  
  var hidden = true
  
	$("#dash_buttons a").mousedown(function() {
	  selectBed($(this));
	  if(hidden) {
	    $("#please").hide(300, function() {
	      $("#dash_controls_wrapper").show();
	    });
	    hidden = false
	  };
	});
  
  var depressed = false
  
	$('#start_button').mousedown(function(){ 
	  if (!$sent && !depressed) {
	    $(this).addClass("start_active");
	    depressed = true
    }
	});
	
	$('#start_button').mouseout(function(){ 
	  $(this).removeClass("start_active");
	  depressed = false
	});
	
	$('#start_button').mouseup(function(){
	  if (depressed && !$sent) {
	    $sent = true
	    depressed = false
	    $(this).removeClass("start_active");
	    activateBed();
	    setTimeout(function() {
	      location.reload();
	    },2500);
    };
	});
	
	$("body").click(function() {
	  return false;
	});
	
	$("#dash_buttons a").click(function() {
	  return false;
	});
	
	getTimeStatus($number_of_beds);
	
	window.setInterval(function() {
	  getTimeStatus($number_of_beds);
  }, 20000);
});
