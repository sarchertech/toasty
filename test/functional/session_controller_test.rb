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

  test "should create new session if authenticated scoped to account" do
    @user = Factory.create(:user, :first_name => "George", :last_name => "Lopez",
                           :account_id => @account.id,
                           :password => "secret", 
                           :password_confirmation => "secret")

    @user2 = Factory.create(:user, :first_name => "George", 
                            :last_name => "Lopez",
                            :account_id => @account.id + 1,
                            :password => "secret", 
                            :password_confirmation => "secret")  
    puts @user.login
    puts @user2.login

    post :create, :login => "glopez1", :password => "secret"
    assert_equal(@user.id, session[:user_id])

    session[:user_id] = nil

    post :create, :login => "glopez2", :password => "secret"
    assert !session[:user_id]
  end

  test "should not create session if password doesn't match" do
    @user = Factory.create(:user, :first_name => "George", :last_name => "Lopez",
                           :account_id => @account.id,
                           :password => "secret", 
                           :password_confirmation => "secret")
    
    post :create, :login => "glopez1", :password => "monkey"
    assert !session[:user_id]
  end
end
