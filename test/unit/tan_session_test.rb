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

  test "bed_id should not be blank" do
    should_not_be_blank(@tan_session, :bed_id)
  end

  test "customer_id should not be blank" do
    should_not_be_blank(@tan_session, :customer_id)
  end

  test "salon_id should not be blank" do
    should_not_be_blank(@tan_session, :salon_id)
  end

  test "minutes should not be blank" do
    should_not_be_blank(@tan_session, :minutes)
  end

  test "minutes should be between 2 and 20" do
    @tan_session.minutes = "one"
    assert !@tan_session.valid?

    @tan_session.minutes = 1
    assert !@tan_session.valid?

    @tan_session.minutes = 21
    assert !@tan_session.valid?
  end
end
