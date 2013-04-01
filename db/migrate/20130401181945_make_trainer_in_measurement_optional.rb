class MakeTrainerInMeasurementOptional < ActiveRecord::Migration
  def change
    change_column :measurements, :trainer_id, :integer, :null => true
  end
end
