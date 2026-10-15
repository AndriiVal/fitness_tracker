require "test_helper"

class WorkoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test "can view own workout" do
    get workout_path(workouts(:one))
    assert_response :success
  end

  test "cannot view another user's workout" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get workout_path(workouts(:two))
    end
  end

  test "cannot change another user's workout" do
    other = workouts(:two)

    assert_raises(ActiveRecord::RecordNotFound) do
      patch workout_path(other), params: { workout: { name: "Unauthorized change" } }
    end
    assert_equal "Back workout", other.reload.name
  end

  test "unknown workout raises not found instead of failing on nil" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get workout_path(id: 999_999_999)
    end
  end

  test "can create a workout scoped to the current user" do
    assert_difference "Workout.count", 1 do
      post workouts_path, params: { workout: { name: "New workout", date: Date.current } }
    end

    assert_equal users(:one), Workout.order(:id).last.user
    assert_redirected_to workout_path(Workout.order(:id).last)
  end
end
