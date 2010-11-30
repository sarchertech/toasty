require 'test_helper'

class TanSessionTest < ActiveSupport::TestCase
  def setup
    @tan_session = Factory.build(:tan_session)
  end

  test "TanSession has valid attributes-no mistakes in migrations" do
    assert_nothing_raised do
      attributes = %w{bed_id customer_id salon_id minutes}
      attributes.each {|attr| @tan_session.send(attr)}
    end
  end
end

