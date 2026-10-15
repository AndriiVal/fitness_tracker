require "test_helper"

class ExercisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test "index only shows own and legacy shared exercises" do
    get exercises_path

    assert_response :success
    assert_select "a[href='#{exercise_path(exercises(:one))}']"
    assert_select "a[href='#{exercise_path(exercises(:legacy))}']"
    assert_select "a[href='#{exercise_path(exercises(:two))}']", count: 0
  end

  test "cannot view another user's exercise" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get exercise_path(exercises(:two))
    end
  end

  test "cannot modify another user's exercise" do
    other = exercises(:two)

    assert_raises(ActiveRecord::RecordNotFound) do
      patch exercise_path(other), params: { exercise: { name: "Changed" } }
    end

    assert_equal "Pull-up", other.reload.name
  end

  test "cannot delete another user's exercise" do
    other = exercises(:two)

    assert_no_difference "Exercise.count" do
      assert_raises(ActiveRecord::RecordNotFound) do
        delete exercise_path(other)
      end
    end

    assert other.reload.persisted?
  end

  test "legacy exercises are visible but read only" do
    legacy = exercises(:legacy)

    get exercise_path(legacy)
    assert_response :success
    assert_select "a[href='#{edit_exercise_path(legacy)}']", count: 0

    assert_raises(ActiveRecord::RecordNotFound) do
      get edit_exercise_path(legacy)
    end
  end

  test "new exercises belong to the signed in user regardless of supplied user_id" do
    assert_difference "Exercise.count", 1 do
      post exercises_path, params: {
        exercise: { name: "Deadlift", description: "Hip hinge", user_id: users(:two).id }
      }
    end

    assert_equal users(:one), Exercise.order(:id).last.user
  end

  test "does not delete an exercise referenced by a training set" do
    exercise = exercises(:one)

    assert_no_difference "Exercise.count" do
      delete exercise_path(exercise)
    end
    assert_redirected_to exercise_path(exercise)
  end
end
