require 'test_helper'
class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get root_path
    assert_response :success
    assert_select "title", "需給管理システム"
  end
end
