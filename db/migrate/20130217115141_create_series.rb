class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
      t.integer :exercise_id, :null => false

      t.foreign_key :exercises, :column => 'exercise_id', :dependent => :delete, :on_update => :cascade

      t.timestamps
    end
    
    add_index :series, :exercise_id
  end
end
