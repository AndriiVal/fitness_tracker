require "test_helper"

class WorkoutTest < ActiveSupport::TestCase
  test "requires a name and date" do
    workout = Workout.new(user: users(:one))

    assert_not workout.valid?
    assert workout.errors[:name].present?
    assert workout.errors[:date].present?
  end

  test "deleting a workout deletes its training sets" do
    workout = workouts(:one)

    assert_difference "TrainingSet.count", -1 do
      workout.destroy!
    end
  end
end
