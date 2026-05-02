class RecipeIngredientProgress < ApplicationRecord
  belongs_to :recipe_ingredient

  validates :user_key, presence: true
  validates :recipe_ingredient_id, uniqueness: { scope: :user_key }
end
