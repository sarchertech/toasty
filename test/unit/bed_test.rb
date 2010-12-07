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
  
  test "salon_id should not be blank" do
    should_not_be_blank(@sundash, :salon_id)
  end

  test "bed_number should not be blank" do
    should_not_be_blank(@sundash, :bed_number)
  end

  test "bed_number should be a number between 1 and 15" do
    @sundash.bed_number = "one"
    assert !@sundash.valid?

    @sundash.bed_number = 0
    assert !@sundash.valid?

    @sundash.bed_number = 16
    assert !@sundash.valid?
  end

  test "level should not be blank" do
    should_not_be_blank(@sundash, :level)
  end 

  test "level should be between 1 and 6" do
    @sundash.level = "one"
    assert !@sundash.valid?

    @sundash.level = 0
    assert !@sundash.valid?

    @sundash.level = 16
    assert !@sundash.valid?
  end

  test "name should not be blank" do
    should_not_be_blank(@sundash, :name)
  end

  test "name should strip leading and trailing whitespace" do
    @sundash.name = " Sundash 5000 "

    @sundash.valid?

    assert_equal("Sundash 5000", @sundash.name)
  end

  test "max_time should not be blank" do
    should_not_be_blank(@sundash, :max_time)
  end

  test "max_time should be between 5 and 20" do
    @sundash.max_time = "one"
    assert !@sundash.valid?
  end
end
