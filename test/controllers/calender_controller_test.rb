require 'test_helper'
class CalenderControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    log_in_as @user
  end

  test "should get new" do
    get calender_index_path(@user)
    assert_response :success
    assert_select "title", "日程詳細 | 需給管理システム"
  end
end
