require 'test_helper'

class SalonsControllerTest < ActionController::TestCase
  setup :initialize_account_and_subdomain
  
  setup do
    @salon = Factory.create(:salon, :account_id => @account.id)
    @salon2 = Factory.create(:salon, :account_id => @account.id + 1)
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
end
