var search_timeout = undefined

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

function showSlider(slider) {
  $(".customer_slider select").attr("disabled", "disabled");
  $(".customer_slider input").attr("disabled", "disabled");
  $(".customer_slider").hide();
  $(slider + " select").attr("disabled", "");
  $(slider).show();
}

$(document).ready(function() {
  $("#customer_search_form").submit(function() {
    return false;
  });

  $("#customer_search_box").bind("keyup", customerSearch); 
  $("#search_filters input").change(customerSearch);
  $("#dropdowns select").change(customerSearch);

  $("nav select").change(function() {
    location.href = $("nav select option:selected").val();
  });

  $("#customer_customer_type_1").click(function() {
    showSlider("#recurring_slider");
  });

  $("#customer_customer_type_2").click(function() {
    showSlider("#per_month_slider");
  });

  $("#customer_customer_type_3").click(function() {
    showSlider("#package_slider");
    $("#package_slider input").attr("disabled", "");
  });

  $("#customer_customer_type_4").click(function() {
    showSlider("#per_session_slider");
  });

  $(".recurring_active #recuccing_slider select").attr("disabled", "");

  $(".per_month_active #per_month_slider select").attr("disabled", "");

  $(".package_active #package_slider select").attr("disabled", "");
  $(".package_active #package_slider input").attr("disabled", "");

  $(".per_session_active #per_session_slider select").attr("disabled", "");

  $(".customer_new #customer_customer_type_1").attr("checked", "checked");

  $(".customer_new #recurring_slider select").attr("disabled", "");
});
