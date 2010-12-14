ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  require 'redgreen'
  
  def should_not_be_blank(model_instance, attr)
    #eval("#{model_instance}.#{attribute}=nil")
    model_instance.send("#{attr}=", nil)

    assert !model_instance.valid?
  end 

  def initialize_account_and_subdomain
    @account = Factory.create(:account)
    @request.host = "#{@account.sub_domain}.local.host"
  end
end
