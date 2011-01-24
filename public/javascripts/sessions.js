function isTmaxLocal() {
}

function getTimeStatus(beds) {
	//alert("foo")
};

$(document).ready(function() {
  $("#new_tan_session").submit(function() {
    var form = $(this)
    var url = "http://localhost:3333/1/"
		var bed = $("#tan_session_bed_id").val();
		var minutes = $("#tan_session_minutes").val();
		var delay = $("#tan_session_delay").val();
		$.get(url + bed + "/" + minutes + "/" + delay);
    return false;
  });

	$("#dash_buttons a").click(function() {
		var num = $(this).attr("data-bed")
		$("#dash_start h2 span").html(num);
		$("#tan_session_bed_id").val(num);
		return false;
	});
	
	getTimeStatus(3);
});
