class CreateSteps < ActiveRecord::Migration[8.1]
  def change
    create_table :steps do |t|
      t.references :recipe, null: false, foreign_key: true
      t.integer :order, null: false
      t.string :title
      t.text :action, null: false
      t.string :time_amount
      t.string :time_unit
      t.boolean :time_per_side
      t.string :time_description
      t.decimal :temperature_amount
      t.string :temperature_unit
      t.string :temperature_description
      t.string :heat_level
      t.text :targets
      t.text :risk_points
      t.text :notes
      t.text :optional_data

      t.timestamps
    end

    add_index :steps, [ :recipe_id, :order ]
  end
end
