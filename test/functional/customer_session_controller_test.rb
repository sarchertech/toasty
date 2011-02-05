require 'test_helper'

class CustomerSessionControllerTest < ActionController::TestCase
  setup :initialize_account_and_subdomain, :initialize_salon

  test "should generate and recognize /customer_login via get" do
    route ={:path => "#{@request.url}/salons/#{@salon.to_param}/customer_login",
      :method => :get }
    action = {:controller => "customer_session", :action => "new",
              :salon_id => @salon.to_param}

    assert_routing(route, action)
  end
  
  test "should generate and recognize /customer_login via post" do
    route = {:path => "#{@request.url}/salons/#{@salon.to_param}/customer_login",
      :method => :post }
    action = {:controller => "customer_session", :action => "create",
              :salon_id => @salon.to_param}

    assert_routing(route, action)
  end
  
  test "should generate and recognize /customer_logout" do
    route ={:path =>"#{@request.url}/salons/#{@salon.to_param}/customer_logout",
      :method => :delete }
    action = {:controller => "customer_session", :action => "destroy",
              :salon_id => @salon.to_param}

    assert_routing(route, action)
  end

  test "should get new" do
    get :new, :salon_id => @salon.to_param
    assert_response :success
  end

  test "should make customer session if customer number matches" do
    @customer = Factory.create(:customer, :customer_number => "1234",
                               :salon_id => @salon.id, 
                               :account_id => @account.id)

    post :create, :salon_id => @salon.to_param, :customer_number => "1234"
    assert_equal(@customer.id, session[:customer_id])
  end

  test "should not make customer session if locked out" do
    @customer = Factory.create(:customer, :customer_number => "1234",
                               :salon_id => @salon.id, 
                               :account_id => @account.id)
    @tan_session = Factory.create(:tan_session, :customer_id => @customer.id,
                                  :salon_id => @salon.id)
    
    post :create, :salon_id => @salon.to_param, :customer_number => "1234"
    assert_equal(nil, session[:customer_id])
  end

  test "should make customer session if not locked out" do
    @customer = Factory.create(:customer, :customer_number => "1234",
                               :salon_id => @salon.id, 
                               :account_id => @account.id)
    @tan_session = Factory.create(:tan_session, :customer_id => @customer.id,
                                  :salon_id => @salon.id, 
                                  :created_at => 1.day.ago)
    
    post :create, :salon_id => @salon.to_param, :customer_number => "1234"
    assert_equal(@customer.id, session[:customer_id])
  end
end
