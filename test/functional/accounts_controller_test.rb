require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  setup :initialize_account_and_subdomain

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accounts)
  end

  test "should get show" do
    get :show, :id => @account.to_param
    assert_response :success
    assert_equal(@account, assigns(:account))
  end 

  test "should get new" do
    get :new
    assert_response :success
    assert assigns(:account).new_record?
  end

  test "should get edit" do
    get :edit, :id => @account.to_param
    assert_response :success
    assert_equal(@account, assigns(:account))
  end

  test "should create account and redirect to account_path" do
    assert_difference('Account.count') do
      post :create,
           :account => Factory.attributes_for(:account, :name => 'Solar Town')
    end

    assert_redirected_to account_path(assigns(:account))
  end

  test "should render new if account not successfully create" do
    post :create, :account => Factory.attributes_for(:account, :name => nil)

    assert_template("new")
  end

  test "should update account and redirect to account_path" do
    put :update, :id => @account.to_param, 
        :account => {:account_number => "123"}
    
    assert_equal("123", @account.reload.account_number)

    assert_redirected_to account_path(assigns(:account))
  end

  test "should render edit if account not successfully updated" do
    put :update, :id => @account.to_param,
                 :account => {:name => nil}

    assert_template("edit")
  end

  test "should destroy account" do
    assert_difference('Account.count', -1) do
      delete :destroy, :id => @account.to_param
    end

    assert_redirected_to accounts_path
  end
end
