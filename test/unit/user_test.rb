require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @michael = Factory.build(:user)
  end

  test "User has valid attributes-no mistakes in migrations" do
    assert_nothing_raised do
      attributes = %w{last_name first_name security_level
                      account_id salon_id login}
      attributes.each {|attr| @michael.send(attr)}
    end
  end
end
