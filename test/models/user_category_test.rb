require 'test_helper'

class UserCategoryTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
    @user_category = UserCategory.new(user_id: users(:michael).id,
                                      category_id: categories(:maintenance).id)
  end

  test "should be valid" do
    assert @user_category.valid?
  end

  test "should require a user_id" do
    @user_category.user_id = nil
    assert_not @user_category.valid?
  end

  test "should require a category_id" do
    @user_category.category_id = nil
    assert_not @user_category.valid?
  end

  test "user_id should be unique" do
    @user.save
    @user.user_categories.create!(category_id: categories(:maintenance).id)
    dup_usercategory = @user.user_categories.build(category_id: categories(:inspection).id)
    assert_not dup_usercategory.valid?
  end

  test "associated user_category should be destroyed" do
    @user.save
    @user_category = @user.user_categories.create!(category_id: categories(:maintenance).id)
    assert_difference 'UserCategory.count', -1 do
      @user.destroy
    end
  end
end
