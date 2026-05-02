class RecipeIngredient < ApplicationRecord
  belongs_to :recipe
  belongs_to :ingredient
  belongs_to :step, optional: true
  has_many :recipe_ingredient_progresses, dependent: :destroy

  validates :ingredient, presence: true
end
