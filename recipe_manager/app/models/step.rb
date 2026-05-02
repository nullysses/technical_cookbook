class Step < ApplicationRecord
  belongs_to :recipe
  has_many :recipe_ingredients, dependent: :nullify
  has_many :step_progresses, dependent: :destroy

  validates :order, :action, presence: true
  validates :order, numericality: { only_integer: true }
end
