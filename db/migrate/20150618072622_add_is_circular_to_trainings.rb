class AddIsCircularToTrainings < ActiveRecord::Migration
  def change
    add_column :trainings, :is_circular, :bool
  end
end
