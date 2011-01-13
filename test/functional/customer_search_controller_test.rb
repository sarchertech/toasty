require 'test_helper'

class CustomerSearchControllerTest < ActionController::TestCase
  setup :initialize_account_and_subdomain, :initialize_salon

  setup do
    @customer = Factory.create(:customer, :salon_id => @salon.id)
    @customer2 = Factory.create(:customer, :salon_id => @salon.id + 1)
  end
  
  test "should generate and recognize /salons/:salon_id/customer_search" do
    route ={:path => "#{@request.url}/salons/#{@salon.to_param}/customer_search",
             :method => :post}
    action = {:controller => "customer_search", :action => "create",
              :salon_id => @salon.to_param}

    assert_routing(route, action)
  end
  
  test "create should return successfull" do
    post :create, :salon_id => @salon.to_param
    assert_response :success
  end

  test "should assign @customers in scoped to salon" do
    post :create, :salon_id => @salon.to_param
    
    assert assigns(:customers)

    assert_equal(@salon.customers, assigns(:customers))
  end

  test "should search by first and last name and filters should work" do
    customer = Factory.create(:customer, :first_name => "seth", :level => 3,
                              :last_name => "brown", :salon_id => @salon.id,
                              :customer_type => 4)
                              
    customer2 = Factory.create(:customer, :first_name => "zane", :level => 2,
                               :last_name => "brown", :salon_id => @salon.id)
    customer3 = Factory.create(:customer, :first_name => "adam", :level => 1,
                               :last_name => "adams", :salon_id => @salon.id)
    customer4 = Factory.create(:customer, :first_name => "richard", :level => 1,
                               :last_name => "adams", :salon_id => @salon.id)

    post :create, :salon_id => @salon.to_param, :search => {:name => "brown"}
    assert_equal(2, assigns(:customers).count)

    post :create, :salon_id => @salon.to_param, :search =>  {:name => "zane"}
    assert_equal(1, assigns(:customers).count)

    post :create, :salon_id => @salon.to_param, :search =>{:name => "adam adams"}
    assert_equal(1, assigns(:customers).count)

    post :create, :salon_id => @salon.to_param, :search=>{:name=>"adams richard"}
    assert_equal(1, assigns(:customers).count)

    post :create, :salon_id => @salon.to_param, 
         :search => {:level => {:three => "3" }}
    assert_equal(1, assigns(:customers).count)

    post :create, :salon_id => @salon.to_param, :search => {:name => "brown",
      :level => {:two => "2"}}
    assert_equal(1, assigns(:customers).count) 

    post :create, :salon_id => @salon.to_param,
         :search => {:type => {:per_session => "4"}}
    assert_equal(1, assigns(:customers).count)

    post :create, :salon_id => @salon.to_param, :search => {:name => "brown",
      :type => {:per_session => "4"}}
    assert_equal(1, assigns(:customers).count)

    tan_session = Factory.create(:tan_session, :customer_id => customer.id)

    post :create, :salon_id => @salon.to_param, 
         :search => {:tanned => {:hhn => "have", :days => "30"}}
    assert_equal(1, assigns(:customers).count)

    post :create, :salon_id => @salon.to_param, 
         :search => {:tanned => {:hhn => "have_not", :days => "30"}}
    assert_equal(4, assigns(:customers).count)
  end
end
