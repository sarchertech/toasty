$(document).ready(function() {
  $("#new_tan_session").submit(function() {
    var form = $(this)
    var url = "http://localhost:3333/"
	var minutes = $("#tan_session_minutes").val();
	$.get(url + minutes);
    return false;
  });
});
