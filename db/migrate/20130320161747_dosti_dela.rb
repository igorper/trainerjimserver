class DostiDela < ActiveRecord::Migration
  
  def change
    create_table :series_executions do |t|
      t.integer :start_timestamp
      t.integer :end_timestamp
      t.integer :exercise_id
      t.integer :num_repetitions
      t.integer :weight
      t.integer :rest_time 
      t.integer :measurement_id      
    end
    
    add_foreign_key :series_executions, :measurements, :column => 'measurement_id', :dependent => :delete, :on_update => :cascade
    add_foreign_key :series_executions , :exercises, :column => 'exercise_id', :dependent => :delete, :on_update => :cascade
    
  end
end
