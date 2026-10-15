require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "users have workouts and owned exercises" do
    user = users(:one)

    assert_includes user.workouts, workouts(:one)
    assert_includes user.exercises, exercises(:one)
    assert_not_includes user.exercises, exercises(:two)
  end
end
