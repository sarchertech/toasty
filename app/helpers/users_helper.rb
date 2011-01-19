module UsersHelper
  def employee_form_submit_button
    if @user.new_record?
      output = '<input class="add_button" type="submit" 
                value="Add Employee"/>'
    else
      output = '<input class="update_button" type="submit" 
                value="Save Changes"/>'
    end

    output.html_safe
  end

  def employee_cancel_changes_link
    unless @user.new_record?
     link_to("Cancel Changes", salon_user_path(@current_salon, @user),
       :class => "cancel_link").html_safe
    end
  end

  def employee_error_handler
    render :partial => 'errors' if @user.errors.any?
  end

end
