require "test_helper"

class ExerciseTest < ActiveSupport::TestCase
  test "requires a name and description" do
    exercise = Exercise.new(user: users(:one))

    assert_not exercise.valid?
    assert_includes exercise.errors[:name], "can't be blank"
    assert_includes exercise.errors[:description], "can't be blank"
  end

  test "rejects duplicate names for one user but allows them for other users" do
    existing = exercises(:one)
    duplicate = Exercise.new(user: users(:one), name: existing.name, description: "Different details")
    other_user = Exercise.new(user: users(:two), name: existing.name, description: "Own details")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
    assert other_user.valid?
  end

  test "visible scope includes own and legacy shared exercises but excludes other users" do
    visible = Exercise.visible_to(users(:one))

    assert_includes visible, exercises(:one)
    assert_includes visible, exercises(:legacy)
    assert_not_includes visible, exercises(:two)
  end

  test "cannot destroy exercise referenced by existing training sets" do
    exercise = exercises(:one)

    assert_no_difference "Exercise.count" do
      assert_not exercise.destroy
    end
    assert exercise.errors[:base].present?
  end
end
