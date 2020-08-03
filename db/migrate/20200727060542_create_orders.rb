class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string     :name
      t.string     :shipment
      t.string     :company_name
      t.string     :unit
      t.integer    :quantity
      t.references :facility, foreign_key: true
      t.references :oil,      foreign_key: true
      t.references :user,     foreign_key: true
      t.datetime   :arrive_at

      t.timestamps
    end
  end
end
