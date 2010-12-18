require 'test_helper'

class BedsControllerTest < ActionController::TestCase
  setup :initialize_account_and_subdomain, :initialize_salon

  setup do
    @bed = Factory.create(:bed, :salon_id => @salon.id)
    @bed2 = Factory.create(:bed, :salon_id => @salon.id + 1)
  end
  
  test "should generate and recognize /salons/:salon_id/beds" do
    route = {:path => "#{@request.url}/salons/#{@salon.to_param}/beds", 
             :method => :get}
    action = {:controller => "beds", :action => "index", 
              :salon_id => @salon.to_param}

    assert_routing(route, action)
  end

  test "should get index and assign beds scoped to current_salon" do
    get :index, :salon_id => @salon.to_param
    assert_response :success

    assert(assigns(:beds))
    assert_equal(@salon.beds, assigns(:beds))
  end

  test "should get show and only assign a bed scoped to current_salon" do
    get :show, :salon_id => @salon.to_param, :id => @bed.to_param
    assert_response :success
    assert_equal(@bed, assigns(:bed))

    assert_raises(ActiveRecord::RecordNotFound) do
      get :show, :salon_id => @salon.to_param, :id => @bed2.to_param
    end
  end

  test "should get new" do
    get :new, :salon_id => @salon.to_param
    assert_response :success
    assert assigns(:bed).new_record?
  end

  test "should get edit and only assign a bed scoped to current_salon" do
    get :edit, :salon_id => @salon.to_param, :id => @bed.to_param
    assert_response :success
    assert_equal(@bed, assigns(:bed))

    assert_raises(ActiveRecord::RecordNotFound) do
      get :edit, :salon_id => @salon.to_param, :id => @bed2.to_param
    end    
  end

  test "should create bed scoped to current_account & redirect" do
    assert_difference('Bed.count') do
      post :create, :salon_id => @salon.to_param, 
           :bed => Factory.attributes_for(:bed, :salon_id => nil)
    end

    assert_equal(@salon.id, assigns(:bed).salon_id)

    assert_redirected_to salon_bed_path(@salon, assigns(:bed))
  end

  test "should render new if bed not successfully created" do
    post :create, :salon_id => @salon.to_param, 
         :bed => Factory.attributes_for(:bed, :level => nil)

    assert_template("new")
  end

  test "should update bed scoped to salon and redirect" do
    put :update, :salon_id => @salon.to_param, :id => @bed.to_param,
        :bed => {:level => "2"}

    assert_equal(2, @bed.reload.level)

    assert_redirected_to salon_bed_path(@salon, @bed)

    assert_raises(ActiveRecord::RecordNotFound) do
      put :update, :salon_id => @salon.to_param, :id => @bed2.to_param
    end
  end

  test "should render edit if bed not successfully updated" do
    put :update, :salon_id => @salon.to_param, :id => @bed.to_param,
                 :bed => {:level => nil}

    assert_template("edit")
  end

  test "should destroy bed scoped to salon" do
    assert_difference("Bed.count", -1) do
      delete :destroy, :salon_id => @salon.to_param, :id => @bed.to_param
    end

    assert_redirected_to salon_beds_path

    assert_raises(ActiveRecord::RecordNotFound) do
      delete :destroy, :salon_id => @salon.to_param, :id => @bed2.to_param
    end
  end
end
