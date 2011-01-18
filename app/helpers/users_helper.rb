module UsersHelper
  def employee_form_submit_button
    if @user.new_record?
      output = '<input id="add_employee_button" type="submit" 
                value="Add Customer"/>'
    else
      output = '<input id="update_employee_button" type="submit" 
                value="Save Changes"/>'
    end

    output.html_safe
  end
end
