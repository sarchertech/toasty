require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  setup :initialize_account_and_subdomain, :initialize_salon

  setup do
    @customer = Factory.create(:customer, :account_id => @account.id,
                               :salon_id => @salon.id)
    @customer2 = Factory.create(:customer, :account_id => @account.id + 1,
                                :salon_id => @salon.id + 1)
    @customer3 = Factory.create(:customer, :account_id => @account.id,
                                :salon_id => @salon.id + 1)
  end

  test "should generate and recognize /salons/:salon_id/customers" do
    route = {:path => "#{@request.url}/salons/#{@salon.to_param}/customers",
             :method => :get}
    action = {:controller => "customers", :action => "index",
              :salon_id => @salon.to_param}

    assert_routing(route, action)
  end

  test "should generate and recognize /customers" do
    route = {:path => "#{@request.url}/customers", :method => :get}
    action = {:controller => "customers", :action => "index"}

    assert_routing(route, action) 
  end

  test "should get index and assign customers scoped to current account" do
    get :index
    assert_response :success

    assert(assigns(:customers))
    assert_equal(@account.customers, assigns(:customers))
  end

  test "should get index and assign customers scoped to current salon" do
    get :index, :salon_id => @salon.to_param
    assert_response :success

    assert_equal(@salon.customers, assigns(:customers))
  end

  test "should get show and assign a customer scoped to current account" do
    get :show, :id => @customer.to_param
    assert_response :success
    assert_equal(@customer, assigns(:customer))

    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, :id => @customer2.to_param
    end
  end

  test "should get show and assign a customer scoped to current salon" do
    get :show, :salon_id => @salon.to_param, :id => @customer.to_param
    assert_response :success 
    assert_equal(@customer, assigns(:customer))

    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, :salon_id => @salon.to_param, :id => @customer3.to_param 
    end
  end
end
