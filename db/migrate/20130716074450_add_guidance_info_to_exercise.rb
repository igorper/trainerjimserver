class AddGuidanceInfoToExercise < ActiveRecord::Migration
  def change
    add_column :exercises, :duration_after_repetition, :integer
    add_column :exercises, :duration_up_repetition, :integer
    add_column :exercises, :duration_middle_repetition, :integer
    add_column :exercises, :duration_down_repetition, :integer
    add_column :exercises, :guidance_type, :string, :null => false, :default => 'manual'
    
    remove_column :series, :duration_after_repetition, :integer
    remove_column :series, :duration_up_repetition, :integer
    remove_column :series, :duration_middle_repetition, :integer
    remove_column :series, :duration_down_repetition, :integer
  end
end
