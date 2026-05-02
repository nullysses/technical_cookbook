class CreateAdjustments < ActiveRecord::Migration[8.1]
  def change
    create_table :adjustments do |t|
      t.references :recipe, null: false, foreign_key: true
      t.text :condition, null: false
      t.text :fix, null: false

      t.timestamps
    end
  end
end
