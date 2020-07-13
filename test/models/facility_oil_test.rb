require 'test_helper'

class FacilityOilTest < ActiveSupport::TestCase
  def setup
    @facility_oil = FacilityOil.new(facility_id: facilities(:first).id,
                                    oil_id: oils(:highoct).id)
  end

  test "should be valid" do
    assert @facility_oil.valid?
  end
end
