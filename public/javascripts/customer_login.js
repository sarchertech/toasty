function focusInput() {
  $("#customer_login_field").focus();
};

$(document).ready(function() {
  focusInput();
  
  $("#customer_login_field").blur(function() {
    setTimeout(function() {
      focusInput();
    },1);
    return false;
  });
  
  $(this).click(function() {
    return false;
  });
  
  $(document)[0].oncontextmenu = function() {
    return false;
  };
});