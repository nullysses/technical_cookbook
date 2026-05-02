class Substitution < ApplicationRecord
  belongs_to :recipe
  has_many :substitutes, dependent: :destroy

  validates :ingredient, presence: true
end
