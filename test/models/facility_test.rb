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

  test "should relate and break_off a user" do
    firstpier = facilities(:first)
    highoct = oils(:highoct)
    assert_not firstpier.oils?(highoct)
    firstpier.relate(highoct)
    assert firstpier.oils?(highoct)
    assert highoct.facilities.include?(firstpier)
    firstpier.break_off(highoct)
    assert_not firstpier.oils?(highoct)
  end
end
