var search_timeout = undefined

$(document).ready(function() {
$("#customer_search_box").bind("keyup", function() {
  if(search_timeout != undefined) {
    clearTimeout(search_timeout);
  }
  
  search_timeout = setTimeout(function() {
    search_timeout = undefined;

    var form = $("#content_wrapper form");
    var url = form.action;  
    var formData = form.serialize();
    $.get(url, formData, function(html) {
      $("#customer_list").html(html);
    });
  }, 250);
}); 
});
