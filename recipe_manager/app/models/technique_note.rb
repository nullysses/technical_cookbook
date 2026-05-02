class TechniqueNote < ApplicationRecord
  belongs_to :recipe

  validates :topic, :note, presence: true
end
