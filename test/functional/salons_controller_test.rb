require 'test_helper'

class SalonsControllerTest < ActionController::TestCase
  setup :initialize_account_and_subdomain
  
  setup do
    @salon = Factory.create(:salon, :account_id => @account.id)
    @salon2 = Factory.create(:salon, :account_id => @account.id + 1)
  end

  test "should generate and recognize /salons" do
    route = {:path => "#{@request.url}/salons", :method => :get}
    action = {:controller => "salons", :action => "index"}

    assert_routing(route, action)
  end

  test "should get index and assign only salons scoped to current_account" do
    get :index
    assert_response :success
    assert_equal(@account.salons, assigns(:salons))
  end

  test "should get show and only assign a salon scoped to current_account" do
    get :show, :id => @salon.to_param
    assert_response :success
    assert_equal(@salon, assigns(:salon))
    
    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, :id => @salon2.to_param
    end
  end

  test "should get new" do
    get :new
    assert_response :success
    assert assigns(:salon).new_record?
  end

  test "should get edit and only assign a salon scoped to current account" do
    get :edit, :id => @salon.to_param
    assert_response :success
    assert_equal(@salon, assigns(:salon))

    assert_raises(ActiveRecord::RecordNotFound) do
      get :edit, :id => @salon2.to_param
    end
  end

  test "should create salon scoped to current_account & redirect" do
    assert_difference('Salon.count') do
      post :create, 
           :salon => Factory.attributes_for(:salon, :account_id => nil)  
    end

    assert_equal(@account.id, assigns(:salon).account_id)

    assert_redirected_to salon_path(assigns(:salon))
  end

  test "should render new if account not successfully created" do
    post :create, :salon => Factory.attributes_for(:salon, :city => nil)

    assert_template("new")
  end

  test "should update salon scoped to account and redirect to salon_path" do
    put :update, :id => @salon.to_param,
        :salon => {:state => "TX"}
    
    assert_equal("TX", @salon.reload.state)

    assert_redirected_to salon_path(@salon)

    assert_raises(ActiveRecord::RecordNotFound) do
      put :update, :id => @salon2.to_param
    end
  end

  test "should render edit if salon not successfully updated" do
    put :update, :id => @salon.to_param,
                 :salon => {:state => nil}

    assert_template("edit")
  end

  test "should destroy salon scoped to account" do
    assert_difference('Salon.count', -1) do
      delete :destroy, :id => @salon.to_param
    end

    assert_redirected_to salons_path

    assert_raises(ActiveRecord::RecordNotFound) do
      delete :destroy, :id => @salon2.to_param
    end
  end
end
