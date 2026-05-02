class Substitute < ApplicationRecord
  belongs_to :substitution

  validates :name, presence: true
end
