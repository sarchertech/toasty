require 'test_helper'

class BedTest < ActiveSupport::TestCase
  def setup
    @sundash = Factory.build(:bed)
  end

  test "Bed has valid attributes-no mistakes in migrations or associations" do
    assert_nothing_raised do
      attributes = %w{salon_id bed_number level name
                      max_time}
      attributes.each {|attr| @sundash.send(attr)}
    end
  end
end
