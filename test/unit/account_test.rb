require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  test "Account has valid attributes-no mistakes in migrations" do
    account = Factory.build(:account)
    
    assert_nothing_raised do
      attributes = %w{account_number name sub_domain}
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

  test "account_number should not be blank" do
    account = Factory.build(:account, :account_number => nil)

    assert !account.valid?
  end

  test "name should not be blank" do
    account = Factory.build(:account, :name => nil)

    assert !account.valid?
  end

  test "name should be alphanumeric " do 
    account = Factory.build(:account, :name => "Sun City's!")

    assert !account.valid?
  end

  test "name should be unique" do
    account = Factory.create(:account, :name => "Sun City")
    account2 = Factory.build(:account, :name => "Sun City")

    assert !account2.valid? 
  end

  test "name uniqueness should not be case sensitive" do
    account = Factory.create(:account, :name => "Sun City")
    account2 = Factory.build(:account, :name => "sun city")

    assert !account2.valid?
  end

  test "extra spaces should not make name unique" do
    account = Factory.create(:account, :name => "Sun City")
    account2 = Factory.build(:account, :name => "Sun  City")

    assert !account2.valid?
  end

  test "sub_domain should be unique" do
    account = Factory.create(:account, :name => "Sun City")
    account2 = Factory.build(:account, :name => "Suncity")

    assert !account2.valid?
  end
end
