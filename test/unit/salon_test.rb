require 'test_helper'

class SalonTest < ActiveSupport::TestCase
  def setup
    @sun_city = Factory.build(:salon)
  end

  test "Salon has valid attributes-no mistakes in migrations" do
    assert_nothing_raised do
      attributes = %w{account_id name zip_code permalink time_zone 
                      address address_2 city state}
      attributes.each {|attr| @sun_city.send(attr)}
    end
  end
end
