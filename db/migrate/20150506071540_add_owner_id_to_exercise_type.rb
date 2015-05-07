class AddOwnerIdToExerciseType < ActiveRecord::Migration
  def change
    add_column :exercise_types, :owner_id, :integer

    add_foreign_key :exercise_types, :users, :column => :owner_id, :on_delete => :cascade, :on_update => :cascade

    add_index :exercise_types, :owner_id
  end
end
