class AddTimestampsToExerciseGroups < ActiveRecord::Migration
  def change
    change_table :exercise_groups do |t|
      t.timestamps
    end
  end
end
