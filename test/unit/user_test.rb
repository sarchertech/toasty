require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @michael = Factory.build(:user)
  end

  test "User has valid attributes-no mistakes in migrations" do
    assert_nothing_raised do
      attributes = %w{last_name first_name security_level
                      account_id salon_id login access_all_locations
                      encrypted_password salt password password_confirmation}
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

  test "password should not be blank" do
    should_not_be_blank(@michael, :password)
  end

  test "should make encryped_password before save" do
    @michael = Factory.create(:user)
    assert @michael.encrypted_password
  end

  test "should make salt before save and not change it on update" do
    @michael = Factory.create(:user)
    assert @michael.salt
    
    salt = @michael.salt

    @michael.password = "supersecret"
    @michael.save
    assert_equal(salt, @michael.salt)
  end

  test "encrypted_password should be secure hash of salt + password" do
    require 'digest'
    @michael = Factory.create(:user, :password => "secret")

    expected =  Digest::SHA2.hexdigest("#{@michael.salt}--#{@michael.password}") 

    assert_equal(expected, @michael.encrypted_password)
  end

  test "password_should not be required on update" do
    @michael = Factory.create(:user, :password => "secret")

    expected = @michael.encrypted_password

    @michael.password = nil
    @michael.first_name = "mike"
    @michael.save

    assert_equal(expected, @michael.encrypted_password)
  end

  test "password_confirmation should be required if password on update" do
    @michael = Factory.create(:user)
    @michael = User.find(@michael.id)

    assert @michael.valid? 

    @michael.password = "supsersecret"

    assert !@michael.valid?
  end

  test "password should be between 6 and 20 characters long" do
    @michael.password = "a"
    @michael.password_confirmation = "a"

    assert !@michael.valid?

    @michael.password = "a" * 21
    @michael.password_confirmation = "a" * 21

    assert !@michael.valid? 
  end

  test "has_password? should return true if encrypted and submitted match" do
    @michael = Factory.create(:user, :password => "secret",
                                     :password_confirmation => "secret")

    assert @michael.has_password?("secret")
    
    assert !@michael.has_password?("supersecret")
  end

  test "password cannot match one of these top passwords" do
    @michael = Factory.build(:user)

    banned_passwords = %w{123456 1234567 12345678 1234567890 password qwerty 
                          abc123 111111 monkey letmein dragon baseball
                          iloveyou sunshine princess tanning 666666 tigger
                          Password PASSWORD iloveu babygirl lovely 654321 
                          password1}

    banned_passwords.each do |pass|
      @michael.password = pass
      @michael.password_confirmation = pass
      assert !@michael.valid?
    end
  end

  test "password cannot contain first or last name" do
    @michael.first_name = "michael"
    @michael.last_name = "krontz"
      
    @michael.password = "123michael123"
    @michael.password_confirmation = "123michael123"
    assert !@michael.valid?
    
    @michael.password = "123krontz123"
    @michael.password_confirmation = "123krontz123"
    assert !@michael.valid?

    @michael.password = "kron10"
    @michael.password_confirmation = "kron10"
    assert @michael.valid?
  end
  
  test "password should not be just spaces" do
    @michael.save
    @michael = User.find(@michael.id)

    @michael.password = " "  
    @michael.password_confirmation = " "

    assert !@michael.valid?
  end   

  test "authenticate should be a class method and take 2 args" do
    assert_nothing_raised do
      User.authenticate("jsmith1", "secret")
    end
  end
end
