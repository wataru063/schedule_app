require 'test_helper'

class FacilityOilTest < ActiveSupport::TestCase
  def setup
    @facility_oil = FacilityOil.new(facility_id: facilities(:first).id,
                                    oil_id: oils(:highoct).id)
  end

  test "should be valid" do
    assert @facility_oil.valid?
  end

  test "should require a follower_id" do
    @facility_oil.facility_id = nil
    assert_not @facility_oil.valid?
  end

  test "should require a followed_id" do
    @facility_oil.oil_id = nil
    assert_not @facility_oil.valid?
  end
end
