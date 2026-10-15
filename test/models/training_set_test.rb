require "test_helper"

class TrainingSetTest < ActiveSupport::TestCase
  test "allows own and legacy shared exercises" do
    training_set = training_sets(:one)

    assert training_set.valid?
    training_set.exercise = exercises(:legacy)
    assert training_set.valid?
  end

  test "rejects an exercise belonging to another user" do
    training_set = training_sets(:one)
    training_set.exercise = exercises(:two)

    assert_not training_set.valid?
    assert_includes training_set.errors[:exercise], "must belong to the workout owner or be shared"
  end

  test "rejects nonpositive repetitions and negative weight" do
    training_set = training_sets(:one)
    training_set.repetitions = 0
    training_set.weight = -1

    assert_not training_set.valid?
    assert training_set.errors[:repetitions].present?
    assert training_set.errors[:weight].present?
  end
end
