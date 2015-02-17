class DoNotCascadeDeleteOnExerciseType < ActiveRecord::Migration
  def change
    remove_foreign_key :exercises, :exercise_types
    add_foreign_key :exercises, :exercise_types, :column => :exercise_type_id, :on_delete => :restrict, :on_update => :cascade
  end
end
