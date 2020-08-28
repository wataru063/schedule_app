require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  def setup
    arrive_day = Time.current.since(4.day).day.to_s
    arrive_month = Time.current.since(4.day).month.to_s
    arrive_year = Time.current.since(4.day).year.to_s
    arrive_at_date = arrive_year + "-" + arrive_month + "-" + arrive_day
    @order = Order.new(name: "Test ship", shipment_id: 1, company_name: "Test company",
                       facility_id: 1, oil_id: 1, unit: "kL",
                       user_id: 1, quantity: 100,
                       arrive_at: Time.current.since(4.day),
                       arrive_at_date: arrive_at_date)

    start_day = Time.current.since(3.month).day.to_s
    start_month = Time.current.since(3.month).month.to_s
    start_year = Time.current.since(3.month).year.to_s
    start_at_date = start_year + "-" + start_month + "-" + start_day
    end_day = Time.current.since(5.month).day.to_s
    end_month = Time.current.since(5.month).month.to_s
    end_year = Time.current.since(5.month).year.to_s
    end_at_date = end_year + "-" + end_month + "-" + end_day
    @construction = Construction.create(name: "Test Work", status: 1,
                                        notice: "For mechanical life", facility_id: 1, oil_id: 1,
                                        category_id: 1, user_id: 1,
                                        start_at: Time.current.since(3.month),
                                        end_at: Time.current.since(5.month),
                                        start_at_date: start_at_date,
                                        end_at_date: end_at_date)
  end

  test "should be valid" do
    assert @order.valid?
  end

  test "name should be present" do
    @order.name = "     "
    assert_not @order.valid?
  end

  test "company_name should be present" do
    @order.company_name = "     "
    assert_not @order.valid?
  end

  test "shipment should be present" do
    @order.shipment_id = " "
    assert_not @order.valid?
  end

  test "unit should be present" do
    @order.unit = " "
    assert_not @order.valid?
  end

  test "quantity should be present" do
    @order.quantity = " "
    assert_not @order.valid?
  end

  test "oil_id should be present" do
    @order.oil_id = " "
    assert_not @order.valid?
  end

  test "user_id should be present" do
    @order.user_id = " "
    assert_not @order.valid?
  end

  test "arrive_at should be present" do
    @order.arrive_at = " "
    assert_not @order.valid?
  end

  test "arrive_at_date should be present" do
    @order.arrive_at_date = " "
    assert_not @order.valid?
  end

  test "combination of arrive_at and facility should be unique" do
    duplicate_order = @order.dup
    @order.save
    assert_not duplicate_order.valid?
  end

  test "combination of arrive_at and facility should not overlap with construction" do
    @order.arrive_at = Time.current.since(4.month)
    assert_not @order.valid?
  end
end
