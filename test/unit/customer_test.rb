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

  test "customer with valid attributes should be valid" do
    assert @rhonda.valid?
  end
  
  test "last_name should not be blank" do
    @rhonda.last_name = nil

    assert !@rhonda.valid?
  end

  test "last_name should be no more than 40 characters long" do
    @rhonda.last_name = "krontzaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

    assert !@rhonda.valid?
  end 

  test "first_name should not be blank" do
    @rhonda.first_name = nil

    assert !@rhonda.valid?
  end

  test "first_name should be no more than 40 characters long" do
    @rhonda.first_name = "Rhondaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

    assert !@rhonda.valid?
  end

  test "last_name should only contain letters, spaces, and hyphens" do
    @rhonda.last_name = "Krontz4"
    assert !@rhonda.valid?
    
    @rhonda.last_name = "Krontz!"
    assert !@rhonda.valid?

    @rhonda.last_name = "Kront\nz"
    assert !@rhonda.valid?

    @rhonda.last_name = "K ront-z"
    assert @rhonda.valid?
  end

  test "first_name should only contain letters, spaces, and hyphens" do
    @rhonda.first_name = "Rhonda4"
    assert !@rhonda.valid?
    
    @rhonda.first_name = "Rhonda!"
    assert !@rhonda.valid?

    @rhonda.first_name = "Rhond\na"
    assert !@rhonda.valid?

    @rhonda.first_name = "R hond-a"
    assert @rhonda.valid?
  end

  test "first and last name should strip leading and trailing spaces" do
    @rhonda.first_name = " Rhonda "
    @rhonda.last_name = " Krontz "

    @rhonda.valid?

    assert_equal("Rhonda", @rhonda.first_name)
    assert_equal("Krontz", @rhonda.last_name)
  end

  test "customer_number should not be blank" do
    @rhonda.customer_number = nil

    assert !@rhonda.valid?
  end

  test "customer_number should strip leading and trailing spaces" do
    @rhonda.customer_number = " 1234 "

    @rhonda.valid?

    assert_equal("1234", @rhonda.customer_number)
  end

  test "level should not be blank" do
    @rhonda.level = nil

    assert !@rhonda.valid?
  end

  test "level should be between 1 and 6" do
    @rhonda.level = 7
    assert !@rhonda.valid?

    @rhonda.level = "seven"
    assert !@rhonda.valid?
  end

  test "email should have an @ and a ." do
    @rhonda.email = "rhondatattoastydotcom"

    assert !@rhonda.valid?
  end

  test "email should be optional" do
    @rhonda.email = nil

    assert @rhonda.valid?
  end

  test "email should strip whitespace" do
    @rhonda.email = " rhonda@toasty.com "
    
    @rhonda.valid?

    assert_equal("rhonda@toasty.com", @rhonda.email)
  end

  test "phone number should not be blank" do
    @rhonda.phone_number = nil

    assert !@rhonda.valid?
  end

  test "phone_number should be a number" do
    @rhonda.phone_number = "six"

    assert !@rhonda.valid?
  end

  test "phone_number should be 10 characters long" do
    @rhonda.phone_number = "123456789"
    assert !@rhonda.valid?

    @rhonda.phone_number = "12345678910"
    assert !@rhonda.valid?
  end

  test "phone_number should strip dashes and periods" do
    @rhonda.phone_number = "770-949.1622"

    @rhonda.valid?

    assert_equal("7709491622", @rhonda.phone_number)
  end

  test "address should not be blank" do
    @rhonda.address = nil

    assert !@rhonda.valid?
  end

  test "birth_date should not be blank" do
    @rhonda.birth_date = nil

    assert !@rhonda.valid?
  end

  test "birth_date should be on or before today" do
    @rhonda.birth_date = Time.now.to_date + 1.day
    assert !@rhonda.valid?

    @rhonda.birth_date = Time.now.to_date
    assert @rhonda.valid?
  end

  test "city should not be blank" do
    @rhonda.city = nil

    assert !@rhonda.valid?
  end

  test "zip_code should not be blank" do
    @rhonda.zip_code = nil

    assert !@rhonda.valid?
  end

  test "zip_code should be a number" do
    @rhonda.zip_code = "three"

    assert !@rhonda.valid?
  end

  test "zip code should be 5 digits long" do
    @rhonda.zip_code = "3013"
    assert !@rhonda.valid?
    
    @rhonda.zip_code = "301345"
    assert !@rhonda.valid?
  end

  test "state should not be blank" do
    @rhonda.state = nil

    assert !@rhonda.valid?
  end

  test "account_id should not be blank" do
    @rhonda.account_id = nil

    assert !@rhonda.valid?
  end

  test "salon_id should not be blank" do
    @rhonda.salon_id = nil

    assert !@rhonda.valid?
  end
end
