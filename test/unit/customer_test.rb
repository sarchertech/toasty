require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  def setup
    @rhonda = Factory.build(:customer)
  end

  test "Customer has valid attributes-no mistakes in migrations" do
    assert_nothing_raised do
      attributes = %w{last_name first_name customer_number level 
                      email phone_number address 
                      city zip_code state account_id 
                      salon_id under_18 customer_type paid_through
                      sessions_left}
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

  test "last_name should only contain letters, and hyphens" do
    @rhonda.last_name = "Krontz4"
    assert !@rhonda.valid?
    
    @rhonda.last_name = "Krontz!"
    assert !@rhonda.valid?

    @rhonda.last_name = "Kront\nz"
    assert !@rhonda.valid?

    @rhonda.last_name = "K rontz"
    assert !@rhonda.valid?

    @rhonda.last_name = "Kront-z"
    assert @rhonda.valid?
  end

  test "first_name should only contain letters, spaces, and hyphens" do
    @rhonda.first_name = "Rhonda4"
    assert !@rhonda.valid?
    
    @rhonda.first_name = "Rhonda!"
    assert !@rhonda.valid?

    @rhonda.first_name = "Rhond\na"
    assert !@rhonda.valid?

    @rhonda.first_name = "R honda"
    assert !@rhonda.valid?

    @rhonda.first_name = "Rhond-a"
    assert @rhonda.valid?
  end

  test "first and last name should strip leading & trailing spaces & downcase" do
    @rhonda.first_name = " Rhonda "
    @rhonda.last_name = " Krontz "

    @rhonda.valid?

    assert_equal("rhonda", @rhonda.first_name)
    assert_equal("krontz", @rhonda.last_name)
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

  test "level should be between 1 and 5" do
    @rhonda.level = 6
    assert !@rhonda.valid?

    @rhonda.level = -1
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

  test "customer_type should be in 1..4" do
    @rhonda.customer_type = 5

    assert !@rhonda.valid? 
  end

  test "paid_through and sessions_left should be blank if customer_type == 1" do
    @rhonda.customer_type = 1
    @rhonda.paid_through = Time.now.to_date + 1.day
    @rhonda.sessions_left = 5

    @rhonda.valid?

    assert_equal(nil, @rhonda.paid_through)
    assert_equal(nil, @rhonda.sessions_left) 
  end

  test "sessions_left should be blank if customer_type == 2" do
    @rhonda.customer_type = 2
    @rhonda.paid_through = Time.now.to_date + 1.day
    @rhonda.sessions_left = 5

    @rhonda.valid?

    assert_equal(nil, @rhonda.sessions_left)
  end 

  test "paid_through should be blank if customer_type == 3" do
    @rhonda.customer_type = 3
    @rhonda.paid_through = Time.now.to_date + 1.day
    @rhonda.sessions_left = 5

    @rhonda.valid?

    assert_equal(nil, @rhonda.paid_through)  
  end

  test "paid_through and sessions_left should be blank if customer_type == 4" do
    @rhonda.customer_type = 4
    @rhonda.paid_through = Time.now.to_date + 1.day
    @rhonda.sessions_left = 5

    @rhonda.valid?

    assert_equal(nil, @rhonda.paid_through)
    assert_equal(nil, @rhonda.sessions_left) 
  end 

  test "paid_through shouldn't be on or before today if customer_type == 2" do
    @rhonda.customer_type = 2
    @rhonda.paid_through = Time.now.to_date
    assert !@rhonda.valid?

    @rhonda.paid_through = Time.now.to_date - 1.day
    assert !@rhonda.valid?

    @rhonda.paid_through = Time.now.to_date + 1.day
    assert @rhonda.valid?

    @rhonda.paid_through = nil
    assert !@rhonda.valid?
  end

  test "sessions_left should be greater than 0 if customer_type == 3" do
    @rhonda.customer_type = 3
    @rhonda.sessions_left = 0
    assert !@rhonda.valid?  

    @rhonda.sessions_left = 3
    assert @rhonda.valid?

    @rhonda.sessions_left = nil
    assert !@rhonda.valid?
  end

  test "word_for_type should return customer type in words" do
    @rhonda.customer_type = 1
    assert_equal("recurring", @rhonda.word_for_type)
    
    @rhonda.customer_type = 2
    assert_equal("per month", @rhonda.word_for_type)
  
    @rhonda.customer_type = 3
    assert_equal("package", @rhonda.word_for_type)
    
    @rhonda.customer_type = 4
    assert_equal("per session", @rhonda.word_for_type)
  end

  test "details should return information based on customer type" do
    @rhonda.customer_type = 2
    @rhonda.paid_through = time = Time.now + 30.days
    expected = "paid through #{time.strftime('%b %d') }"
    assert_equal(expected, @rhonda.details)

    @rhonda.customer_type = 3
    @rhonda.sessions_left = 5   
    assert_equal("5 sessions left", @rhonda.details)
  end

  test "state should be a valid postal abbreviation" do
    @rhonda.state = "xx"

    assert !@rhonda.valid?
  end

  test "state should automatically upcase" do
    @rhonda.state = "tx"

    @rhonda.valid?

    assert_equal("TX", @rhonda.state)
  end
end
