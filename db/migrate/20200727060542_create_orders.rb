class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string   :name
      t.string   :company_name
      t.string   :unit
      t.integer  :shipment
      t.integer  :quantity
      t.integer  :facility_id
      t.integer  :oil_id
      t.integer  :user_id
      t.datetime :arrive_at

      t.timestamps
    end
  end
end
