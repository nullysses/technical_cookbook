class Recipe < ApplicationRecord
  before_validation :infer_stable_id_from_title

  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :steps, -> { order(:order) }, dependent: :destroy
  has_many :technique_notes, dependent: :destroy
  has_many :substitutions, dependent: :destroy
  has_many :adjustments, dependent: :destroy
  has_one :storage, dependent: :destroy

  validates :stable_id, :title, :version, presence: true
  validates :stable_id, uniqueness: true

  def to_param
    stable_id
  end

  private

  def infer_stable_id_from_title
    self.stable_id = title.to_s.parameterize if title.present?
  end
end
