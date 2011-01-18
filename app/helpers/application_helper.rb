module ApplicationHelper
  def flash_handler
    if flash[:notice]
      %Q{<div id="flash"><p id="notice">#{flash[:notice]}</p></div>'}.html_safe
    elsif flash[:alert]
      %Q{<div id="flash"><p id="alert">#{flash[:alert]}</p></div>}.html_safe
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

  def salons_dropdown
    if @current_salon
      render :partial => 'shared/salons_dropdown_with_salon'
    else
      render :partial => 'shared/salons_dropdown_no_salon'
    end
  end

  def dropdown_url(salon)
    url_for :action => params[:action], :salon_id => salon, :id => params[:id]
  end

  def dropdown_all
    begin 
      url = url_for :action => params[:action], :salon_id => nil, :id => params[:id]
      
      %Q{<option value="url">All Salons</option>}.html_safe
    rescue
      nil
    end
  end
end
