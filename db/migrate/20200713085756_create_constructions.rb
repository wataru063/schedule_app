class CreateConstructions < ActiveRecord::Migration[5.1]
  def change
    create_table :constructions do |t|
      t.string     :name
      t.string     :status
      t.text       :notice
      t.references :facility, foreign_key: true
      t.references :oil,      foreign_key: true
      t.references :category, foreign_key: true
      t.references :user,     foreign_key: true
      t.datetime   :start_at
      t.datetime   :end_at

      t.timestamps
    end
  end
end
