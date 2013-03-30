class CreateExercises < ActiveRecord::Migration
  def change
    
    create_table :exercises do |t|
      t.references :training, :null => false
      t.references :exercise_type, :null => false
      t.integer :order

      t.foreign_key :trainings, :column => :training_id, :dependent => :delete, :on_update => :cascade
      t.foreign_key :exercise_types, :column => :exercise_type_id, :dependent => :delete, :on_update => :cascade

      t.timestamps
    end
    
    add_index :exercises, :training_id
    add_index :exercises, :exercise_type_id
  end
end
