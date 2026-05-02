class CreateStorages < ActiveRecord::Migration[8.1]
  def change
    create_table :storages do |t|
      t.references :recipe, null: false, foreign_key: true, index: { unique: true }
      t.decimal :refrigerator_duration
      t.string :refrigerator_unit
      t.decimal :freezer_duration
      t.string :freezer_unit
      t.text :reheat

      t.timestamps
    end

  end
end
