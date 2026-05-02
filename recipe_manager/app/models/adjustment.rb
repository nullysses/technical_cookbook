class Adjustment < ApplicationRecord
  belongs_to :recipe

  validates :condition, :fix, presence: true
end
