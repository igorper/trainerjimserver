class CreateExercises < ActiveRecord::Migration
  def change
    
    create_table :exercises do |t|
      t.integer :training_id, :null => false
      t.string :name
      t.integer :order

      t.foreign_key :trainings, :column => 'training_id', :dependent => :delete, :on_update => :cascade

      t.timestamps
    end
    
    add_index :exercises, :training_id
  end
end
