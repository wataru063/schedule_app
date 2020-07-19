require 'test_helper'

class ConstructionRegisterTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    start_day = Time.current.since(3.month).day.to_s
    start_month = Time.current.since(3.month).month.to_s
    start_year = Time.current.since(3.month).year.to_s
    @start_at_date = start_year + "-" + start_month + "-" + start_day
    end_day = Time.current.since(4.month).day.to_s
    end_month = Time.current.since(4.month).month.to_s
    end_year = Time.current.since(4.month).year.to_s
    @end_at_date = end_year + "-" + end_month + "-" + end_day
  end
  test "invalid registration information" do
    get construction_path(@user)
    assert_no_difference 'Construction.count', 1 do
      post constructions_path, params: { construction: { name: "",
                                                         status: "",
                                                         facility_id: "",
                                                         oil_id: "",
                                                         category_id: "",
                                                         user_id: "",
                                                         start_at_date: "",
                                                         "start_at(1i)" =>
                                                            Time.current.since(3.month).year.to_s,
                                                         "start_at(2i)" =>
                                                            Time.current.since(3.month).month.to_s,
                                                         "start_at(3i)" =>
                                                            Time.current.since(3.month).day.to_s,
                                                         "start_at(4i)" =>
                                                            Time.current.since(3.month).hour.to_s,
                                                         "start_at(5i)" =>
                                                            Time.current.since(3.month).min.to_s,
                                                         end_at_date: "",
                                                         "end_at(1i)" =>
                                                            Time.current.since(4.month).year.to_s,
                                                         "end_at(2i)" =>
                                                            Time.current.since(4.month).month.to_s,
                                                         "end_at(3i)" =>
                                                            Time.current.since(4.month).day.to_s,
                                                         "end_at(4i)" =>
                                                            Time.current.since(4.month).hour.to_s,
                                                         "end_at(5i)" =>
                                                            Time.current.since(4.month).min.to_s,
                                                         notice: "" },
                                         category_id: @user.category_id }
    end
    assert_template 'constructions/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
  end

  test "valid registration information" do
    get construction_path(@user)
    assert_difference 'Construction.count', 1 do
      post constructions_path, params: { construction: { name: "Test",
                                                         status: "Test",
                                                         facility_id: 1,
                                                         oil_id: 1,
                                                         category_id: @user.category_id,
                                                         user_id: @user.id,
                                                         start_at_date: @start_at_date,
                                                         "start_at(1i)" =>
                                                            Time.current.since(3.month).year.to_s,
                                                         "start_at(2i)" =>
                                                            Time.current.since(3.month).month.to_s,
                                                         "start_at(3i)" =>
                                                            Time.current.since(3.month).day.to_s,
                                                         "start_at(4i)" =>
                                                            Time.current.since(3.month).hour.to_s,
                                                         "start_at(5i)" =>
                                                            Time.current.since(3.month).min.to_s,
                                                         end_at_date: @end_at_date,
                                                         "end_at(1i)" =>
                                                            Time.current.since(4.month).year.to_s,
                                                         "end_at(2i)" =>
                                                            Time.current.since(4.month).month.to_s,
                                                         "end_at(3i)" =>
                                                            Time.current.since(4.month).day.to_s,
                                                         "end_at(4i)" =>
                                                            Time.current.since(4.month).hour.to_s,
                                                         "end_at(5i)" =>
                                                            Time.current.since(4.month).min.to_s,
                                                         notice: "Test" },
                                         category_id: @user.category_id }
    end
    follow_redirect!
    assert_template 'constructions/new'
    assert_not flash.empty?
  end
end
