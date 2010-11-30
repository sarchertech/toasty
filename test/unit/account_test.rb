require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def setup
    @account = Factory.build(:account)
  end

  test "Account has valid attributes-no mistakes in migrations" do
    assert_nothing_raised do
      attributes = %w{customer_location_access user_location_access
                      time_zone account_number name sub_domain}
      attributes.each {|attr| @account.send(attr)}
    end
  end
end
