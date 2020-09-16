require 'test_helper'
class OrdersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    log_in_as @user
  end

  test "should get new" do
    get new_order_path
    assert_response :success
    assert_select "title", "オーダー登録 | 需給管理システム"
  end

  test "should get index" do
    get orders_path
    assert_response :success
    assert_select "title", "オーダー一覧 | 需給管理システム"
  end
end
