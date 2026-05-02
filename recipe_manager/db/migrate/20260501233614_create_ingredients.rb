class CreateIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :ingredients do |t|
      t.references :recipe, null: false, foreign_key: true
      t.string :name, null: false
      t.string :amount
      t.string :unit
      t.string :state
      t.string :preparation
      t.string :section
      t.boolean :optional
      t.text :notes

      t.timestamps
    end

    add_index :ingredients, [ :recipe_id, :section, :name ]
  end
end
