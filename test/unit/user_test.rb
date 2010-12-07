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
  
  test "customer with valid attributes should be valid" do
    assert @michael.valid?
  end

  test "last_name should not be blank" do
    should_not_be_blank(@michael, :last_name) 
  end

  test "last_name should be no more than 40 characters long" do
    @michael.last_name = "krontzaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

    assert !@michael.valid?
  end 

  test "last_name should strip leading and trailing whitespace" do
    @michael.last_name = " Krontz "
    
    @michael.valid?

    assert_equal("Krontz", @michael.last_name)
  end

  test "last_name should only contain letters, spaces, and hyphens" do
    @michael.last_name = "Krontz4"
    assert !@michael.valid?
    
    @michael.last_name = "Krontz!"
    assert !@michael.valid?

    @michael.last_name = "Kront\nz"
    assert !@michael.valid?

    @michael.last_name = "K ront-z"
    assert @michael.valid?
  end
end
