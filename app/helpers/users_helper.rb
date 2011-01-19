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
end
