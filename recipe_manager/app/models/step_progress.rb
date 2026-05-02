class StepProgress < ApplicationRecord
  belongs_to :step

  validates :user_key, presence: true
  validates :step_id, uniqueness: { scope: :user_key }
end
