module ApplicationHelper
  def flash_handler
    if flash[:notice]
      %Q{<p class="notice">#{flash[:notice]}</p>'}.html_safe
    elsif flash[:alert]
      %Q{<p class="alert">#{flash[:alert]}</p>}.html_safe
    end
  end

  def main_nav
    if @current_salon
      render :partial => 'shared/main_nav_with_salon'
    else
      render :partial => 'shared/main_nav_no_salon' 
    end
  end

  def phone_number(string)
    string[0..2] + "-" + string[3..5] + "-" + string[6..9]
  end
end
