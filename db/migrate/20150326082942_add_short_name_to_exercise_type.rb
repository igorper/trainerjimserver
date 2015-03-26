class AddShortNameToExerciseType < ActiveRecord::Migration
  def up
    add_column :exercise_types, :short_name, :string
    ExerciseType.update_all('short_name = name')
  end

  def down
    remove_column :exercise_types, :short_name
  end
end
