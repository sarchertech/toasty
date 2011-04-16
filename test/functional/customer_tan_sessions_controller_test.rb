require 'test_helper'

class CustomerTanSessionsControllerTest < ActionController::TestCase
  setup :initialize_account_and_subdomain, :initialize_salon

  setup do
    @bed = Factory.create(:bed, :salon_id => @salon.id)
    @bed = Factory.create(:bed, :salon_id => @salon.id + 1)
    @customer = Factory.create(:customer, :salon_id => @salon.id)
    session[:customer_id] = @customer.id
  end

  test "should get new" do
    get :new, :salon_id => @salon.to_param
    assert_response :success
  end

  test "new should assign salon.beds to @beds" do
    get :new, :salon_id => @salon.to_param
    assert_equal(@salon.beds, assigns(:beds))
  end

  test "new should assign @tan_session and should be new_record" do
    get :new, :salon_id => @salon.to_param
    assert assigns(:tan_session).new_record?
  end

  test "should create tan_session" do
    @bed = Factory.create(:bed, :salon_id => @salon.id, :bed_number => 2)
    
    bed = @salon.beds.find_by_bed_number(2)
    
    assert_difference('TanSession.count') do
      post :create, :salon_id => @salon.to_param, 
           :tan_session => {:minutes => "5", :bed => "2"}    
    end
  end

  test "should not require logged in user" do
    session[:user_id] = nil
    
    get :new, :salon_id => @salon.to_param
    assert_response :success
  end

  test "should deduct tan from customer_type 3 when tan session created" do
    @customer.customer_type = 3
    @customer.sessions_left = 2
    @customer.save
      
    post :create, :salon_id => @salon.to_param, 
         :tan_session => {:minutes => "5", :bed => "1"}    

    assert_equal(1, @customer.reload.sessions_left)
  end
end
