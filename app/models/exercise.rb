class Exercise < ApplicationRecord
  # Exercises created before ownership was introduced remain shared/read-only.
  belongs_to :user, optional: true

  has_many :training_sets, dependent: :restrict_with_error
  has_many :workouts, through: :training_sets

  scope :visible_to, ->(user) { where(user_id: [nil, user.id]) }

  validates :name, presence: true, uniqueness: { scope: :user_id }
  validates :description, presence: true
end
