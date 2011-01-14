require 'test_helper'

class EmployeePasswordControllerTest < ActionController::TestCase
  setup :initialize_account_and_subdomain, :initialize_salon

  test "should generate and recognize /employee_password via get" do
    route ={:path=>"#{@request.url}/change_password",
            :method => :get}
    action = {:controller => "employee_password", :action => "edit"}

    assert_routing(route, action)
  end

  test "should generate and recognize /employee_password via put" do
    route ={:path=>"#{@request.url}/change_password",
            :method => :put}
    action = {:controller => "employee_password", :action => "update"}

    assert_routing(route, action)
  end
end
