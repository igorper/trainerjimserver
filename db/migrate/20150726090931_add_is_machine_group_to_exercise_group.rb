class AddIsMachineGroupToExerciseGroup < ActiveRecord::Migration
  def change
    add_column :exercise_groups, :is_machine_group, :boolean, null: false, default: false
  end
end
