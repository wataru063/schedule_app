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
end
