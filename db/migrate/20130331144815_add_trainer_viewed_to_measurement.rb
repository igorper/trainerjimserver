class AddTrainerViewedToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :trainerViewed, :boolean, :null => false, :default => false
  end
end
