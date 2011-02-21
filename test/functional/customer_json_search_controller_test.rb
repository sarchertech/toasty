require 'test_helper'

class CustomerJsonSearchControllerTest < ActionController::TestCase
  setup :initialize_account_and_subdomain, :initialize_salon

  setup do
    @customer = Factory.create(:customer, :salon_id => @salon.id)
    @customer2 = Factory.create(:customer, :salon_id => @salon.id + 1)
  end

  test "should generate and recognize /salons/:salon_id/customer_json_search" do
    string = "#{@request.url}/salons/#{@salon.to_param}/customer_json_search"
    route ={ :path => string, :method => :post}
    action = {:controller => "customer_json_search", :action => "create",
              :salon_id => @salon.to_param}

    assert_routing(route, action)
  end

  test "create should return successfull if customers found & properly scoped" do
    post :create, :salon_id => @salon.to_param, :name => "krontz", :format=> "js"
    assert_response :success
    assert_equal(@salon.customers, assigns(:customers))
  end

  test "should search by name" do
    customer = Factory.create(:customer, :first_name => "seth",
                              :last_name => "brown", :salon_id => @salon.id,)
                              
    customer2 = Factory.create(:customer, :first_name => "zane",
                               :last_name => "brown", :salon_id => @salon.id)

    post :create, :salon_id => @salon.to_param, :name => "seth", :format=> "js"
    assert_equal(1, assigns(:customers).length)
    
    post :create, :salon_id => @salon.to_param, :name => "brown", :format=> "js"
    assert_equal(2, assigns(:customers).length)

    post :create, :salon_id => @salon.to_param, :name => "lazarus", :format=>"js"
    assert_equal(0, assigns(:customers).length)
    assert_response 404

    post :create, :salon_id => @salon.to_param, :name => "", :format=> "js"
    assert_equal(0, assigns(:customers).length)
    assert_response 404   
  end

  test "should render proper format in json" do
    customer = Factory.create(:customer, :first_name => "seth", 
                              :last_name => "brown", :salon_id => @salon.id,)
  
    post :create, :salon_id => @salon.to_param, :name => "seth", :format => "js"
    json = customer.to_json(:only => [:id, :first_name, :last_name])
    
    json_response = @response.body
    assert_equal("[" + json + "]", json_response)
  end
end
