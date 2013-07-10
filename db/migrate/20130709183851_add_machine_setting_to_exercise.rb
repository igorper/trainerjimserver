class AddMachineSettingToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :machine_setting, :string
  end
end
