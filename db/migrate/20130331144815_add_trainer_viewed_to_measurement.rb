class AddTrainerViewedToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :trainer_seen, :boolean, :null => false, :default => false
  end
end
