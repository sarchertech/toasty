require 'test_helper'

class SessionControllerTest < ActionController::TestCase
  setup :initialize_account_and_subdomain

  test "should generate and recognize /login via get" do
    route = {:path => "#{@request.url}/login", :method => :get }
    action = {:controller => "session", :action => "new"}

    assert_routing(route, action)
  end
  
  test "should generate and recognize /login via post" do
    route = {:path => "#{@request.url}/login", :method => :post }
    action = {:controller => "session", :action => "create"}

    assert_routing(route, action)
  end
  
  test "should generate and recognize /logout" do
    route = {:path => "#{@request.url}/logout", :method => :delete }
    action = {:controller => "session", :action => "destroy"}

    assert_routing(route, action)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create new session if authenticated" do
    
  end
end
