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
    get :index, :controller => "beds", :salon_id => @salon.to_param
    assert_response :success

    assert(assigns(:beds))
    assert_equal(@salon.beds, assigns(:beds))
  end
end
