require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "Account has valid attributes-no mistakes in migrations" do
    account = Factory.build(:account)
    
    assert_nothing_raised do
      attributes = %w{customer_location_access user_location_access
                      account_number name sub_domain}
      attributes.each {|attr| account.send(attr)}
    end
  end

  test "Account should strip leading and trailing whitespace from name" do
    account = Factory.create(:account, :name => " Sun City ")

    assert_equal("Sun City", account.name)
  end

  test "Account should create a sub_domain and it should be url safe" do
    account = Factory.create(:account, :name => "Sun City")  
        
    assert_equal("suncity", account.sub_domain) 
  end

  test "customer_location_access should not be blank" do
    account = Factory.build(:account, :customer_location_access => nil)

    assert !account.valid?
  end 

  test "user_location_access should not be blank" do
    account = Factory.build(:account, :user_location_access => nil)

    assert !account.valid?
  end

  test "account_number should not be blank" do
    account = Factory.build(:account, :account_number => nil)

    assert !account.valid?
  end

  test "name should be alphanumeric " do 
    account = Factory.build(:account, :name => "Sun City's!")

    assert !account.valid?
  end
end
