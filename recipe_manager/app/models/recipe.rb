class Recipe < ApplicationRecord
  before_validation :infer_stable_id_from_title, on: :create

  has_many :recipe_ingredients, dependent: :destroy
  has_many :ingredients, through: :recipe_ingredients
  has_many :steps, -> { order(:order) }, dependent: :destroy
  has_many :technique_notes, dependent: :destroy
  has_many :substitutions, dependent: :destroy
  has_many :adjustments, dependent: :destroy
  has_one :storage, dependent: :destroy

  validates :stable_id, :title, :version, presence: true
  validates :stable_id, uniqueness: true
  validates :stable_id,
    format: {
      with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/,
      message: "must use lowercase letters, numbers, and single hyphens"
    },
    allow_blank: true

  def to_param
    stable_id
  end

  private

  def infer_stable_id_from_title
    return if stable_id.present?
    return if title.blank?

    self.stable_id = unique_stable_id_from(title)
  end

  def unique_stable_id_from(value)
    base = value.to_s.parameterize
    candidate = base
    suffix = 2

    while self.class.exists?(stable_id: candidate)
      candidate = "#{base}-#{suffix}"
      suffix += 1
    end

    candidate
  end
end
