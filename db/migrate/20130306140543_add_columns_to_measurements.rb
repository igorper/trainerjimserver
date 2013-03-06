class AddColumnsToMeasurements < ActiveRecord::Migration
  def change
    add_column :measurements, :training_id, :integer
    add_column :measurements, :start_time, :timestamp
    add_column :measurements, :end_time, :timestamp

    add_foreign_key :measurements, :trainings, :column => 'training_id', :dependent => :delete, :on_update => :cascade
    
    add_index :measurements, :training_id
  end
end
