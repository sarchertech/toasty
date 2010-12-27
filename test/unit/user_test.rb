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

  test "first_name should not be blank" do
    should_not_be_blank(@michael, :first_name)
  end

  test "last_name should be no more than 40 characters long" do
    @michael.last_name = "krontzaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

    assert !@michael.valid?
  end 
  
  test "last_name should be at leaset 2 characters long" do
    @michael.last_name = "k"

    assert !@michael.valid?
  end

  test "first_name should be no more than 40 characters long" do
    @michael.first_name = "michaelaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

    assert !@michael.valid?
  end

  test "last_name should strip leading and trailing whitespace and downcase." do
    @michael.last_name = " Krontz "
    
    @michael.valid?

    assert_equal("krontz", @michael.last_name)
  end

  test "first_name should strip leading and trailing whitespace and downcase." do
    @michael.first_name = " Michael "
    
    @michael.valid?

    assert_equal("michael", @michael.first_name)
  end

  test "last_name should only contain letters, and hyphens" do
    @michael.last_name = "Krontz4"
    assert !@michael.valid?
    
    @michael.last_name = "Krontz!"
    assert !@michael.valid?

    @michael.last_name = "Kront\nz"
    assert !@michael.valid?

    @michael.last_name = "K rontz"
    assert !@michael.valid?

    @michael.last_name = "Kront-z"
    assert @michael.valid?
  end

  test "first_name should only contain letters, and hyphens" do
    @michael.first_name = "Michael4"
    assert !@michael.valid?
    
    @michael.first_name = "Michael!"
    assert !@michael.valid?

    @michael.first_name = "Michae\nl"
    assert !@michael.valid?

    @michael.first_name = "M ichael"
    assert !@michael.valid?

    @michael.first_name = "Michae-l"
    assert @michael.valid?
  end

  test "security_level should not be blank" do
    should_not_be_blank(@michael, :security_level)
  end

  test "security level should be a number from 1 to 4" do
    @michael.security_level = -1
    assert !@michael.valid?

    @michael.security_level = 5
    assert !@michael.valid?
  end

  test "account_id should not be blank" do
    should_not_be_blank(@michael, :account_id)
  end
  
  test "login should be autocreated and free of hypens" do
    user = Factory.create(:user, :last_name => "Kr-ontzey",
                          :first_name => "-Michael") 
    
    assert_equal("mkrontz1", user.login)  
  end

  test "login should + number if already taken & only change when neccessary" do
    user = Factory.create(:user, :last_name => "Brown", :first_name => "Zed")
    user2 = Factory.create(:user, :last_name => "Brown", :first_name => "Zane")
    user3 = Factory.create(:user, :last_name => "Brown", :first_name => "Zeke")

    #TODO also need to bypass validations with Factory girl so I can check to
    #     see if zbrown233 increments to zbrown234

    assert_equal("zbrown2", user2.login)
    assert_equal("zbrown3", user3.login)

    user3.save

    assert_equal("zbrown3", user3.login)

    user3.first_name = "Xray"
    user3.save

    assert_equal("xbrown1", user3.login)

    user3.last_name = "Browne"
    user3.save

    assert_equal("xbrowne1", user3.login)
  end
end
