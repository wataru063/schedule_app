require 'test_helper'

class ConstructionTest < ActiveSupport::TestCase
  def setup
    start_day = Time.current.since(3.month).day.to_s
    start_month = Time.current.since(3.month).month.to_s
    start_year = Time.current.since(3.month).year.to_s
    start_at_date = start_year + "-" + start_month + "-" + start_day
    end_day = Time.current.since(4.month).day.to_s
    end_month = Time.current.since(4.month).month.to_s
    end_year = Time.current.since(4.month).year.to_s
    end_at_date = end_year + "-" + end_month + "-" + end_day
    @construction = Construction.new(name: "Test Work", status: 1,
                                     notice: "For mechanical life", facility_id: 1, oil_id: 1,
                                     category_id: 1, user_id: 1,
                                     start_at: Time.current.since(3.month),
                                     end_at: Time.current.since(4.month),
                                     start_at_date: start_at_date,
                                     end_at_date: end_at_date)
  end

  test "should be valid" do
    assert @construction.valid?
  end

  test "name should be present" do
    @construction.name = "     "
    assert_not @construction.valid?
  end

  test "status should be present" do
    @construction.status = " "
    assert_not @construction.valid?
  end

  test "oil_id should be present" do
    @construction.oil_id = " "
    assert_not @construction.valid?
  end

  test "category_id should be present" do
    @construction.category_id = " "
    assert_not @construction.valid?
  end

  test "user_id should be present" do
    @construction.user_id = " "
    assert_not @construction.valid?
  end

  test "start_at should be present" do
    @construction.start_at = " "
    assert_not @construction.valid?
  end

  test "end_at should be present" do
    @construction.end_at = " "
    assert_not @construction.valid?
  end

  test "start_at should be two months later" do
    @construction.start_at = Time.current
    assert_not @construction.valid?
  end

  test "end_at should be later than start_at" do
    @construction.end_at = Time.current.since(2.month)
    assert_not @construction.valid?
  end
end
