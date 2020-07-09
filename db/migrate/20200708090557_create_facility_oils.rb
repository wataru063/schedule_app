class CreateFacilityOils < ActiveRecord::Migration[5.1]
  def change
    create_table :facility_oils do |t|
      t.integer :facility_id
      t.integer :oil_id

      t.timestamps
    end
    add_index :facility_oils, :facility_id
    add_index :facility_oils, :oil_id
    add_index :facility_oils, [:facility_id, :oil_id], unique: true
  end
end
