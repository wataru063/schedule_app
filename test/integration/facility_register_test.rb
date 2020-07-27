require 'test_helper'

class FacilityRegisterTest < ActionDispatch::IntegrationTest
  test "invalid registration information" do
    get facility_path
    assert_no_difference 'Facility.count', 1 do
      post facilities_path, params: { facility: { name: "", oil_id: "" } }
    end
    assert_template 'facilities/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end

  test "valid registration information" do
    get facility_path
    assert_difference 'Facility.count', 1 do
      post facilities_path, params: { facility: { name: "test", oil_id: 1 } }
    end
    follow_redirect!
    assert_template 'facilities/new'
    assert_not flash.empty?
  end
end
