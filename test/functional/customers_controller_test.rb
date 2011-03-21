require 'test_helper'

class CustomersControllerTest < ActionController::TestCase
  setup :initialize_account_and_subdomain, :initialize_salon, :initialize_user

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

  #test "should get index and assign customers scoped to current account" do
    #get :index
    #assert_response :success

    #assert(assigns(:customers))
    #assert_equal(@account.customers, assigns(:customers))
  #end

  test "should get index and assign customers scoped to current salon" do
    get :index, :salon_id => @salon.to_param
    assert_response :success

    assert_equal(@salon.customers, assigns(:customers))
  end

  #test "should get show and assign a customer scoped to current account" do
    #get :show, :id => @customer.to_param
    #assert_response :success
    #assert_equal(@customer, assigns(:customer))

    #assert_raises(ActiveRecord::RecordNotFound) do
      #get :show, :id => @customer2.to_param
    #end
  #end

  test "should get show and assign a customer scoped to current salon" do
    get :show, :salon_id => @salon.to_param, :id => @customer.to_param
    assert_response :success 
    assert_equal(@customer, assigns(:customer))

    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, :salon_id => @salon.to_param, :id => @customer3.to_param 
    end
  end

  test "should get new" do
    get :new, :salon_id => @salon.to_param
    assert_response :success 
    assert assigns(:customer).new_record?
  end

  test "should default state to current_salons state" do
    get :new, :salon_id => @salon.to_param

    assert_equal(@salon.state, assigns(:customer).state)
  end
  
  #test "should get edit and assign a customer scoped to current account" do
    #get :edit, :id => @customer.to_param
    #assert_response :success
    #assert_equal(@customer, assigns(:customer))

    #assert_raises(ActiveRecord::RecordNotFound) do
      #get :edit, :id => @customer2.to_param
    #end
  #end

  test "should get edit and assign a customer scoped to current salon" do
    get :edit, :salon_id => @salon.to_param, :id => @customer.to_param
    assert_response :success
    assert_equal(@customer, assigns(:customer))

    assert_raises(ActiveRecord::RecordNotFound) do
      get :edit, :salon_id => @salon.to_param, :id => @customer3.to_param
    end
  end

  #test "should create customer scoped to current_account & redirect" do
    #assert_difference('Customer.count') do
      #post :create, :customer => Factory.attributes_for(:customer, 
        #:salon_id => @salon.to_param, :account_id => nil)
    #end 

    #assert_equal(@account.id, assigns(:customer).account_id)
    #assert_equal(@salon.id, assigns(:customer).salon_id)

    #assert_redirected_to customer_path(assigns(:customer))
  #end

  test "should create customer scoped to current salon & redirect" do
    assert_difference('Customer.count') do
      post :create, :salon_id => @salon.to_param, 
           :customer => Factory.attributes_for(:customer, 
             :salon_id => nil, :account_id => nil)
    end 
    
    assert_equal(@account.id, assigns(:customer).account_id)
    assert_equal(@salon.id, assigns(:customer).salon_id)

    assert_redirected_to salon_customer_path(@salon, assigns(:customer))
  end

  test "should not raise error if create customers has no customer params" do
    assert_nothing_raised do
      post :create, :salon_id => @salon.to_param
    end
  end

  test "should render new if customer not successfully created" do
     post :create, :salon_id => @salon.to_param, 
       :customer => Factory.attributes_for(:customer, :account_id => nil, 
                                           :state => nil)

     assert_template("new")
  end

  #test "should update customer scoped to account and redirect" do
    #put :update, :id => @customer.to_param, :customer => {:level => "2"}

    #assert_equal(2, @customer.reload.level) 

    #assert_redirected_to customer_path(@customer)

    #assert_raises(ActiveRecord::RecordNotFound) do
      #put :update, :id => @customer2.to_param
    #end
  #end

  test "should update customer scoped to salon and redirect" do
    put :update, :salon_id => @salon.to_param, :id => @customer.to_param,
        :customer => {:level => "2"}
    
    assert_equal(2, @customer.reload.level)

    assert_redirected_to salon_customer_path(@salon, @customer)

    assert_raises(ActiveRecord::RecordNotFound) do
      put :update, :salon_id => @salon.to_param, :id => @customer3
    end
  end

  test "should render edit if customer not successfully updated" do
    put :update, :salon_id => @salon.to_param, :id => @customer.to_param, 
        :customer => {:state => nil}

    assert_template("edit")
  end

  #test "should destroy customer scoped to account" do
    #assert_difference("Customer.count", -1) do
      #delete :destroy, :id => @customer.to_param
    #end

    #assert_redirected_to customers_path

    #assert_raises(ActiveRecord::RecordNotFound) do
      #delete :destroy, :id => @customer2.to_param 
    #end
  #end

  test "should destroy customer scoped to salon" do
    assert_difference("Customer.count", -1) do
      delete :destroy, :salon_id => @salon.to_param, :id => @customer.to_param
    end

    assert_redirected_to salon_customers_path(@salon)

    assert_raises(ActiveRecord::RecordNotFound) do
      delete :destroy, :salon_id => @salon.to_param, :id => @customer3.to_param
    end
  end

  test "customer should require a logged in user" do
    session[:user_id] = nil

    get :index, :salon_id => @salon.to_param
    assert_response :redirect
  end

  test "customer should require a user authorized to work here" do
    user = Factory.create(:user, :salon_id => @salon.id + 1)
    session[:user_id] = user.id

    get :index, :salon_id => @salon.to_param
    assert_response :redirect

    user.salon_id = @salon.id
    user.save
    get :index, :salon_id => @salon.to_param
    assert_response :success
  end

  test "user should be logged in if admin even if not scoped to account" do
    user=Factory.create(:user, :account_id =>@account.id+1, :security_level => 4)
    session[:user_id] = user.id

    get :index, :salon_id => @salon.to_param
    assert_response :success
  end
end
