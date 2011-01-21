require 'test_helper'

class TanSessionsControllerTest < ActionController::TestCase
  setup :initialize_account_and_subdomain, :initialize_salon

  setup do
    @bed = Factory.create(:bed, :salon_id => @salon.id)
    @bed = Factory.create(:bed, :salon_id => @salon.id + 1)
  end

  test "should get new" do
    get :new, :salon_id => @salon.to_param
    assert_response :success
  end

  test "new should assign salon.besds to @beds" do
    get :new, :salon_id => @salon.to_param
    assert_equal(@salon.beds, assigns(:beds))
  end

  test "new should assign @tan_session and should be new_record" do
    get :new, :salon_id => @salon.to_param
    assert assigns(:tan_session).new_record?
  end
end
