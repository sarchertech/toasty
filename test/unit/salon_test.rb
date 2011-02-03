require 'test_helper'

class SalonTest < ActiveSupport::TestCase
  def setup
    @sun_city = Factory.build(:salon)
  end

  test "Salon has valid attributes-no mistakes in migrations" do
    assert_nothing_raised do
      attributes = %w{account_id zip_code identifier time_zone 
                      address address_2 city state staffed_hours
                      static_ip auto_ip}
      attributes.each {|attr| @sun_city.send(attr)}
    end
  end

  test "Salon with valid attributes should be valid" do
    salon = Factory.build(:salon)

    assert salon.valid?
  end

  test "Salon has to belong to an account" do
    salon = Factory.build(:salon, :account_id => nil)
    
    assert !salon.valid?
  end

  test "zip_code cannot be blank" do
    salon = Factory.build(:salon, :zip_code => nil)

    assert !salon.valid?
  end

  test "zip code must be at least 5 characters long" do
    salon = Factory.build(:salon, :zip_code => "3013")

    assert !salon.valid?
  end

  test "zip code must be no more than 5 characters long" do
    salon = Factory.build(:salon, :zip_code => "301345")

    assert !salon.valid?
  end 

  test "zip code must be a number" do
    salon = Factory.build(:salon, :zip_code => "three")

    assert !salon.valid?
  end

  test "zip code must not have any spaces" do
    salon = Factory.build(:salon, :zip_code => "301 4")
    
    assert !salon.valid?
  end

  test "time_zone must not be blank" do
    salon = Factory.build(:salon, :time_zone => nil)

    assert !salon.valid?
  end

  test "time zone should be valid us time zone" do
    salon = Factory.build(:salon, :time_zone => "easteern")

    assert !salon.valid?
  end

  test "address should not be blank" do
    salon = Factory.build(:salon, :address => nil)

    assert !salon.valid?
  end

  test "city should not be blank" do
    salon = Factory.build(:salon, :city => nil)

    assert !salon.valid?
  end

  test "state should not be blank" do
    salon = Factory.build(:salon, :state => nil)

    assert !salon.valid?
  end

  test "identifier should not be blank" do
    salon = Factory.build(:salon, :identifier => nil)

    assert !salon.valid?
  end

  test "identifier should be no more than 12 characters long" do
    salon = Factory.build(:salon, :identifier => "mariettaville")

    assert !salon.valid?
  end

  test "identifier should be unique within an account" do
    account = Factory.create(:account, :name => "Unique1")
    account2 = Factory.create(:account, :name => "Unique2")
    salon = Factory.create(:salon, :identifier => "douglasville", 
                           :account => account)
    salon2 = Factory.build(:salon, :identifier => "douglasville",
                           :account => account)
    salon3 = Factory.build(:salon, :identifier => "douglasville",
                           :account => account2)

    assert !salon2.valid?
    assert salon3.valid?
  end

  test "identifier should have only alphanumeric characters and underscores" do
    salon = Factory.build(:salon, :identifier => "Doug!")
    assert !salon.valid?

    salon.identifier = "D oug"
    assert !salon.valid? 

    salon.identifier = " D_oug "
    assert salon.valid?
  end

  test "identifier should automatically lower case any letter" do
    salon = Factory.create(:salon, :identifier => "BALLGROUND")

    assert_equal("ballground", salon.identifier)
  end

  test "to_param should return salon.identifier" do
    assert_equal(@sun_city.identifier, @sun_city.to_param)
  end
end
