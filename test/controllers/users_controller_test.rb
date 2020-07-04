require 'test_helper'
class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "title", "新規登録 | 需給管理システム"
  end
end
