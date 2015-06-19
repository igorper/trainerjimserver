class MakeIsCircularInTrainingsNonNullable < ActiveRecord::Migration
  def change
    Training.where(is_circular: nil).update_all(is_circular: false)
    change_column :trainings, :is_circular, :boolean, null: false
  end
end
