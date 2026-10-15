class TrainingSet < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise

  validates :repetitions, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :weight, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validate :exercise_accessible_to_workout_owner

  private

  def exercise_accessible_to_workout_owner
    return if exercise.nil? || workout.nil?
    return if exercise.user_id.nil? || exercise.user_id == workout.user_id

    errors.add(:exercise, "must belong to the workout owner or be shared")
  end
end
