module ApplicationHelper
  def flash_handler
    if flash[:notice]
      %Q{<p class="notice">#{flash[:notice]}</p>'}.html_safe
    elsif flash[:alert]
      %Q{<p class="alert">#{flash[:alert]}</p>}.html_safe
    end
  end
end
