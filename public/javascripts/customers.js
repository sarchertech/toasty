$(document).ready(function() {
$("#customer_search_box").bind("keyup", function() {
  //$("#customer_search_box").addClass("loading"); // show the spinner
  var form = $("#content_wrapper form");// grab the form wrapping the search bar.
  var url = form.action; // live_search action.  
  var formData = form.serialize(); // grab the data in the form  
  $.get(url, formData, function(html) { // perform an AJAX get
    //$("#customer_search_box").removeClass("loading"); // hide the spinner
    $("#customer_list").html(html); // replace the "results" div with the results
  });
}); 
});
