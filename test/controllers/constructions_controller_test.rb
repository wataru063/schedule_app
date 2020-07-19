require 'test_helper'
class ConstructionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "should get new" do
    get construction_path(@user)
    assert_response :success
    assert_select "title", "工事登録 | 需給管理システム"
  end
end
