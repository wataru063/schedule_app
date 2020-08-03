require 'test_helper'
class ConstructionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @construction = constructions(:pipe_repair)
    @user = users(:michael)
    log_in_as @user
  end

  test "should get new" do
    get new_construction_path(@user)
    assert_response :success
    assert_select "title", "工事登録 | 需給管理システム"
  end

  test "should get index" do
    get constructions_path
    assert_response :success
    assert_select "title", "工事一覧 | 需給管理システム"
  end
end
