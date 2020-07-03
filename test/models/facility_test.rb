require 'test_helper'

class FacilityTest < ActiveSupport::TestCase
 def setup
    @facility = Facility.new(name: "テスト桟橋")
  end

  test "should be valid" do
    assert @facility.valid?
  end

  test "name should be present" do
    @facility.name = "     "
    assert_not @facility.valid?
  end

  test "name should not be too long" do
    @facility.name = "a" * 51
    assert_not @facility.valid?
  end

  test "name should be unique" do
    duplicate_facility = @facility.dup
    @facility.save
    assert_not duplicate_facility.valid?
  end
end
