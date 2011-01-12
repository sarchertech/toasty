require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup :initialize_account_and_subdomain, :initialize_salon

  setup do
    @user = Factory.create(:user, :account_id => @account.id,
                               :salon_id => @salon.id)
    @user2 = Factory.create(:user, :account_id => @account.id + 1,
                                :salon_id => @salon.id + 1)
    @user3 = Factory.create(:user, :account_id => @account.id,
                                :salon_id => @salon.id + 1)
  end

  test "should generate and recognize /salons/:salon_id/users" do
    route = {:path => "#{@request.url}/salons/#{@salon.to_param}/users",
             :method => :get}
    action = {:controller => "users", :action => "index",
              :salon_id => @salon.to_param}

    assert_routing(route, action)
  end

  test "should generate and recognize /users" do
    route = {:path => "#{@request.url}/users", :method => :get}
    action = {:controller => "users", :action => "index"}

    assert_routing(route, action) 
  end

  test "should get index and assign users scoped to current account" do
    get :index
    assert_response :success

    assert(assigns(:users))
    assert_equal(@account.users, assigns(:users))
  end

  test "should get index and assign users scoped to current salon" do
    get :index, :salon_id => @salon.to_param
    assert_response :success

    assert_equal(@salon.users, assigns(:users))
  end

  # commenting out until we add support for viewing account.users
  #test "should get show and assign a user scoped to current account" do
    #get :show, :id => @user.to_param
    #assert_response :success
    #assert_equal(@user, assigns(:user))

    #assert_raises(ActiveRecord::RecordNotFound) do
      #get :show, :id => @user2.to_param
    #end
  #end

  test "should get show and assign a user scoped to current salon" do
    get :show, :salon_id => @salon.to_param, :id => @user.to_param
    assert_response :success 
    assert_equal(@user, assigns(:user))

    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, :salon_id => @salon.to_param, :id => @user3.to_param 
    end
  end

  test "should get new" do
    get :new
    assert_response :success 
    assert assigns(:user).new_record?
  end
  
  test "should get edit and assign a user scoped to current account" do
    get :edit, :id => @user.to_param
    assert_response :success
    assert_equal(@user, assigns(:user))

    assert_raises(ActiveRecord::RecordNotFound) do
      get :edit, :id => @user2.to_param
    end
  end

  test "should get edit and assign a user scoped to current salon" do
    get :edit, :salon_id => @salon.to_param, :id => @user.to_param
    assert_response :success
    assert_equal(@user, assigns(:user))

    assert_raises(ActiveRecord::RecordNotFound) do
      get :edit, :salon_id => @salon.to_param, :id => @user3.to_param
    end
  end

  test "should create user scoped to current_account & redirect" do
    assert_difference('User.count') do
      post :create, :user => Factory.attributes_for(:user, 
        :salon_id => @salon.to_param, :account_id => nil)
    end 

    assert_equal(@account.id, assigns(:user).account_id)
    assert_equal(@salon.id, assigns(:user).salon_id)

    assert_redirected_to user_path(assigns(:user))
  end

  test "should create user scoped to current salon & redirect" do
    assert_difference('User.count') do
      post :create, :salon_id => @salon.to_param, 
           :user => Factory.attributes_for(:user, 
             :salon_id => nil, :account_id => nil)
    end 
    
    assert_equal(@account.id, assigns(:user).account_id)
    assert_equal(@salon.id, assigns(:user).salon_id)

    assert_redirected_to salon_user_path(@salon, assigns(:user))
  end

  test "should render new if user not successfully created" do
     post :create, :user => Factory.attributes_for(:user, 
       :salon_id => @salon.to_param, :account_id => nil, :first_name => nil)

     assert_template("new")
  end

  test "should update user scoped to account and redirect" do
    put :update, :id => @user.to_param, :user => {:first_name => "jeff"}

    assert_equal("jeff", @user.reload.first_name) 

    assert_redirected_to user_path(@user)

    assert_raises(ActiveRecord::RecordNotFound) do
      put :update, :id => @user2.to_param
    end
  end

  test "should update user scoped to salon and redirect" do
    put :update, :salon_id => @salon.to_param, :id => @user.to_param,
        :user => {:first_name => "jeff"}
    
    assert_equal("jeff", @user.reload.first_name) 

    assert_redirected_to salon_user_path(@salon, @user)

    assert_raises(ActiveRecord::RecordNotFound) do
      put :update, :salon_id => @salon.to_param, :id => @user3
    end
  end

  test "should render edit if user not successfully updated" do
    put :update, :id => @user.to_param, :user => {:first_name => nil}

    assert_template("edit")
  end

  test "should destroy user scoped to account" do
    assert_difference("User.count", -1) do
      delete :destroy, :id => @user.to_param
    end

    assert_redirected_to users_path

    assert_raises(ActiveRecord::RecordNotFound) do
      delete :destroy, :id => @user2.to_param 
    end
  end

  test "should destroy user scoped to salon" do
    assert_difference("User.count", -1) do
      delete :destroy, :salon_id => @salon.to_param, :id => @user.to_param
    end

    assert_redirected_to salon_users_path(@salon)

    assert_raises(ActiveRecord::RecordNotFound) do
      delete :destroy, :salon_id => @salon.to_param, :id => @user3.to_param
    end
  end
end
