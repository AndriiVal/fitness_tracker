require "test_helper"

class TrainingSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end

  test "new form only offers own and shared exercises" do
    get new_workout_training_set_path(workouts(:one))

    assert_response :success
    assert_select "option[value='#{exercises(:one).id}']"
    assert_select "option[value='#{exercises(:legacy).id}']"
    assert_select "option[value='#{exercises(:two).id}']", count: 0
  end

  test "rejects creating a set with another user's exercise" do
    assert_no_difference "TrainingSet.count" do
      post workout_training_sets_path(workouts(:one)), params: {
        training_set: { exercise_id: exercises(:two).id, repetitions: 8, weight: 10 }
      }
    end

    assert_response :unprocessable_entity
  end

  test "allows creating a set with a legacy shared exercise" do
    assert_difference "TrainingSet.count", 1 do
      post workout_training_sets_path(workouts(:one)), params: {
        training_set: { exercise_id: exercises(:legacy).id, repetitions: 8, weight: 10 }
      }
    end

    assert_redirected_to workout_path(workouts(:one))
  end

  test "cannot edit a set belonging to another workout" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get edit_workout_training_set_path(workouts(:one), training_sets(:two))
    end
  end

  test "cannot update another user's set through their workout" do
    assert_raises(ActiveRecord::RecordNotFound) do
      patch workout_training_set_path(workouts(:two), training_sets(:two)), params: {
        training_set: { repetitions: 99 }
      }
    end
    assert_equal 1, training_sets(:two).reload.repetitions
  end

  test "missing training set raises not found" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get edit_workout_training_set_path(workouts(:one), id: 999_999_999)
    end
  end
end
