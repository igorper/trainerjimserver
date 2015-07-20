class RemoveColumnsFromMeasurements < ActiveRecord::Migration
  def change
    remove_column :measurements, :trainer_id
    remove_column :measurements, :data
    remove_column :measurements, :trainer_seen
  end
end
