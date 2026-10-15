class AddUserToExercises < ActiveRecord::Migration[7.0]
  def change
    # Preserve existing exercises: records without an owner remain shared/read-only.
    add_reference :exercises, :user, null: true, index: true, foreign_key: true
  end
end
