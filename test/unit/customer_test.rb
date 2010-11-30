require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  def setup
    @rhonda = Factory.build(:customer)
  end

  test "Customer has valid attributes-no mistakes in migrations" do
    assert_nothing_raised do
      attributes = %w{last_name first_name customer_number level 
                      email phone_number address address_2 
                      birth_date city zip_code state account_id 
                      salon_id}
      attributes.each {|attr| @rhonda.send(attr)}
    end
  end
end
