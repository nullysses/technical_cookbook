class CreateRecipeIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :recipe_ingredients do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :ingredient, null: false, foreign_key: true
      t.string :amount
      t.string :unit
      t.string :state
      t.string :preparation
      t.string :section
      t.boolean :optional
      t.text :notes

      t.timestamps
    end

    add_index :recipe_ingredients, [ :recipe_id, :ingredient_id ]
    add_index :recipe_ingredients, [ :recipe_id, :section ]
  end
end
