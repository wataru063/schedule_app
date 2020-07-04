require 'test_helper'

class OilTest < ActiveSupport::TestCase
  def setup
    @oil = Oil.new(name: "テスト油")
  end

  test "should be valid" do
    assert @oil.valid?
  end

  test "name should be present" do
    @oil.name = "     "
    assert_not @oil.valid?
  end

  test "name should not be too long" do
    @oil.name = "a" * 51
    assert_not @oil.valid?
  end

  test "name should be unique" do
    duplicate_oil = @oil.dup
    @oil.save
    assert_not duplicate_oil.valid?
  end
end
