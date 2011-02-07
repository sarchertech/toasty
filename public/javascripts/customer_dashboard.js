function activateBed() {
  var url = $activate_url;
	var bed = $("#tan_session_bed").val();
	var minutes = $("#tan_session_minutes").val();
	var a = $("#_" + bed + " a")
	if ( a.attr("data-bed-status") == "4" ) {
	  resetBed();
	};
	$.ajax({
	  url: url + bed + "/" + minutes + "/" + $delay,
	  success: function() {
	    createSession();
  	  //var a = $("#_" + bed + " a")
  	  $("#post_active").html("Bed " + bed + " Will Activate <br /> in 6 Minutes");
  	  $("#dash_controls_wrapper").hide(0, function() {
  	    $("#post_active").fadeIn(1000);
  	  });
	  },
	  error: function(){
	    $sent = false
	    alert('bed not activated please try again');
	  }
	});

	$("#_" + bed).removeClass().addClass("_1");

  $("#_" + bed).attr("data-bed-loading", "1");
	$("#bed_activated p").html("Bed " + bed + " Activated");
	$("#bed_activated").fadeIn().delay(300).fadeOut('slow');
};

function resetBed() {
  bed = $("#tan_session_bed").val();
  url = $reset_url + bed;
  $.get(url);
  alert("Please clean the bed before you tan");
};

function createSession() {
  var url = $form.attr("action");
  var data = $form.serialize();
  $.post(url, data);
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
    var bedli = $("#_" + val.number);
    var bed = bedli.children("a");
    var disabled = bed.attr("data-bed-disabled");
    if (!disabled) {
      bed.attr("data-bed-status", val.status);
      if (val.status == "0") {
        bedli.removeClass().addClass("green");
      }
      else if (val.status == "4" && bed.attr("data-session-over") == "true" && !val.time) {
        bedli.removeClass().addClass("green");
      }
      else {
        bedli.removeClass().addClass("red");
      };
    };
  });
};

function disableBeds() {
  $("#dash_buttons li a").each(function() {
    var bed = $(this)
    var bl = bed.attr("data-bed-level");
    if ($cl < bl) {
      bed.attr("data-bed-disabled", "disabled");
    }
  });
};

function selectBed(a) {
	par = a.parent();
	if (par.hasClass("green")) {
	  var num = a.attr("data-bed");
  	var max = a.attr("data-maxtime");
  	var level = a.attr("data-bed-level")
  	
  	$("#dash_buttons a").removeClass("bed_active");
  	a.addClass("bed_active");
  	$("#dash_start h2 span").html(num);
  	$("#tan_session_bed").val(num);
  	$time_box.attr("data-maxtime", max);
  	$("#max_time").html("Max Time " + max + " Minutes");
  	$("#bed_level").html("Level " + level + " Bed")
  	if(+$time_box.val() > max ) {
  		$time_box.val(max);
  	};
  	if($hidden) {
	    $("#please").hide(300, function() {
	      $("#dash_controls_wrapper").show();
	    });
	    $hidden = false
	  };
  };
	return false;
};

$(document).ready(function() {
  $ip = "192.168.1.2";
  $activate_url = "http://" + $ip + ":4567/1/";
  $status_url = "http://" + $ip + ":4568/";
  $reset_url = "http://" + $ip + ":4567/2/"
  $number_of_beds = 6;
  $delay = 6;
  $form = $("#new_tan_session")
  $index = $("#tan_session_minutes");
  $time_box = $("#tan_session_minutes");
  $cl = $("#bottom_level").attr("data-customer-level")
  $sent = false;
  $hidden = true;
  
  disableBeds();
	
	getTimeStatus($number_of_beds);
  
  $("body").click(function() {
    return false;
  });
  
  $("body").mousedown(function() {
    return false;
  });
  
  //$(document)[0].oncontextmenu = function() {return false;}
  
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
  
  $("#new_tan_session").submit(function() {
    return false;
  });
  
	$("#dash_buttons a").mousedown(function() {
	  selectBed($(this));
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
	    //setTimeout(function() {
	      //location.reload();
	    //},2500);
    };
	});
	
	$("body").click(function() {
	  return false;
	});
	
	$("#dash_buttons a").click(function() {
	  return false;
	});
	
	/*window.setInterval(function() {
	  getTimeStatus($number_of_beds);
  }, 20000);*/
});
