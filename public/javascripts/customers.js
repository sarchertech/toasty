var search_timeout = undefined;

function customerSearch() {
  if(search_timeout != undefined) {
    clearTimeout(search_timeout);
  }
  
  search_timeout = setTimeout(function() {
    search_timeout = undefined;

    var form = $("#content_wrapper form");
    var url = form.attr("action");  
    var formData = form.serialize();
    $.post(url, formData, function(html) {
      $("#customer_list").html(html);
    });
  }, 250);
}

function showActiveSlider() {
  var active_slider = $("#sliders").attr("data-active-slider");
  var active_select = active_slider + " select";
  var active_input = active_slider + " input";

  //$(active_select + "," + active_input).attr("disabled", "");
  //$(active_slider).show();
  showSlider(active_slider);
}

function showSlider(slider) {
  $("#sliders div select").attr("disabled", "disabled");
  $("#sliders div input").attr("disabled", "disabled");
  $("#sliders div").hide();
  $(slider + " select").attr("disabled", "");
  $(slider + " input").attr("disabled", "");
  $(slider).show();
}

$(document).ready(function() {
  $("input").attr("autocomplete", "off")

  $("#customer_search_form").submit(function() {
    return false;
  });

  $("#customer_search_box").bind("keyup", customerSearch); 
  $("#search_filters input").change(customerSearch);
  $("#dropdowns select").change(customerSearch);

  $("nav select").change(function() {
    location.href = $("nav select option:selected").val();
  });

  showActiveSlider();

  $("#radio_button_wrapper input").click(function() {
    var selected = $(this).attr("data-slider-name")
    showSlider(selected);
  });
});
