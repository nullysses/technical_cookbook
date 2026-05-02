class AddStepToRecipeIngredients < ActiveRecord::Migration[8.1]
  def change
    add_reference :recipe_ingredients, :step, foreign_key: true
    add_index :recipe_ingredients, [ :recipe_id, :step_id ]
  end
end
