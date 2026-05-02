class CreateRecipeIngredientProgresses < ActiveRecord::Migration[8.1]
  def change
    create_table :recipe_ingredient_progresses do |t|
      t.references :recipe_ingredient, null: false, foreign_key: true
      t.string :user_key, null: false

      t.timestamps
    end

    add_index :recipe_ingredient_progresses, [ :recipe_ingredient_id, :user_key ], unique: true
  end
end
