class AddDescriptionToExerciseType < ActiveRecord::Migration
  def change
    add_column :exercise_types, :description, :string
  end
end
