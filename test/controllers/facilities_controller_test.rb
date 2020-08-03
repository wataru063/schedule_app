require 'test_helper'
class FacilitiesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get facility_path
    assert_response :success
    assert_select "title", "荷役設備登録 | 需給管理システム"
  end
end
