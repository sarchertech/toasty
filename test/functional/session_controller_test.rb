require 'test_helper'

class SessionControllerTest < ActionController::TestCase
  setup :initialize_account_and_subdomain, :initialize_salon

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

    post :create, :login => "glopez1", :password => "secret"
    assert_equal(@user.id, session[:user_id])

    session[:user_id] = nil

    post :create, :login => "glopez2", :password => "secret"
    assert !session[:user_id]
  end

  test "should not create session if user doesn't match" do
    post :create, :login => "superman", :password => "monkey"
    assert !session[:user_id]
  end

  test "should not allow wrong password or too many wrong attempts" do
    @user = Factory.create(:user, :first_name => "George", :last_name => "Lopez",
                           :account_id => @account.id,
                           :password => "secret", 
                           :password_confirmation => "secret")
    
    post :create, :login => "glopez1", :password => "secret"
    assert_equal(@user.id, session[:user_id])

    session[:user_id] = nil
    10.times { post :create, :login => "glopez1", :password => "monkey" }
    assert !session[:user_id]

    post :create, :login => "glopez1", :password => "secret"
    assert !session[:user_id]
  end

  test "should reset password_attempts to 0 on login" do
    @user = Factory.create(:user, :first_name => "George", :last_name => "Lopez",
                           :account_id => @account.id,
                           :password => "secret", 
                           :password_confirmation => "secret")

    @user.password_attempts = 5 
    @user.save

    post :create, :login => "glopez1", :password => "secret"
    assert_equal(0, @user.reload.password_attempts)
  end

  test "should destroy session on logout" do
    session[:user_id] = 1 
    
    delete :destroy

    assert !session[:user_id]
  end

  test "session should not require a loggin in user" do
    session[:user_id] = nil
    
    get :new
    assert_response :success
  end
end
