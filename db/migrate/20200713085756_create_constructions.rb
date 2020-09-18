class CreateConstructions < ActiveRecord::Migration[5.1]
  def change
    create_table :constructions do |t|
      t.string   :name
      t.text     :notice
      t.integer  :status_id
      t.integer  :facility_id
      t.integer  :oil_id
      t.integer  :category_id
      t.integer  :user_id
      t.datetime :start_at
      t.datetime :end_at

      t.timestamps
    end
  end
end
