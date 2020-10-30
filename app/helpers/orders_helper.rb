module OrdersHelper
require 'csv'
  # export to csv
  def to_csv_order(orders)
    CSV.generate do |csv|
      columns_ja = %w(No. 船名 会社名 入出荷 対象設備 油種 数量 単位 担当者名 荷役作業日時)
      columns = %w(no name company_name shipment facility_name oil_name
                   quantity unit user_name arrive_at)
      csv << columns_ja
      no = 1
      orders.each do |order|
        order_attr = order.attributes
        order_attr["no"] = no
        order_attr["name"] = order.name
        order_attr["company_name"] = order.company_name
        order_attr["shipment"] = order.shipment.name
        order_attr["oil_name"] = order.oil.name
        order_attr["facility_name"] = order.facility.name
        order_attr["user_name"] = order.user.name
        order_attr["quantity"] = order.quantity
        order_attr["unit"] = order.unit
        order_attr["arrive_at"] = order.arrive_at.strftime("%Y年%m月%d日%H時%M分")
        csv << order_attr.values_at(*columns)
        no += 1
      end
    end
  end

  def set_order_times
    operate_params = params[:order].present? ? params[:order] : params
    reset_time(operate_params, :arrive)
    set_time(operate_params, :arrive)
  end

  def set_orders
    @all_orders = Order.all
    @shipment = Shipment.all
    @facility_id = Order.order('facility_id ASC').select(:facility_id).distinct
    @oil_id = Order.order('oil_id ASC').select(:oil_id).distinct
    @sort_column = params[:column].presence || 'arrive_at'
    if params[:controller] == "admin/orders"
      @orders = Order.search(search_params)
      @count  = @orders.count
      @orders = @orders.order(@sort_column + ' ' + sort_direction).page(params[:page]).per(9)
    else
      @orders = Order.search(search_params).order(@sort_column + ' ' + sort_direction).
        page(params[:page]).per(7)
    end
    @search_params = search_params
  end

  def set_order_select
    @shipment = Shipment.all
    @all_facilities = Facility.all
    if params[:facility_id].present?
      @facility = params[:facility_id]
      @oils = Facility.find(params[:facility_id]).oils
    else
      @facility = Facility.first.id
      @oils = Facility.first.oils
    end
    @user = User.all
  end
end
