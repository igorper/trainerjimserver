class CreateSeriesExecutions < ActiveRecord::Migration
  
  def change
    create_table :series_executions do |t|
      t.integer :start_timestamp
      t.integer :end_timestamp
      t.references :exercise_type, :null => false
      t.integer :num_repetitions
      t.integer :weight
      t.integer :rest_time 
      t.references :measurement, :null => false
      t.integer :duration_seconds, :default => 0
    end
    
    add_foreign_key :series_executions, :measurements, :column => :measurement_id, :dependent => :delete, :on_update => :cascade
    add_foreign_key :series_executions , :exercise_types, :column => :exercise_type_id, :dependent => :delete, :on_update => :cascade
    add_index :series_executions, :measurement_id
    add_index :series_executions, :exercise_type_id
    
  end
end
