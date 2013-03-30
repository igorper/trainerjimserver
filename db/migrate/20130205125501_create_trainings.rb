class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.integer :trainee_id, :null => true
      t.string :name
      t.integer :original_training_id, :null => true
      
      t.foreign_key :users, :column => :trainee_id, :dependent => :delete, :on_update => :cascade
      t.foreign_key :trainings, :column => :original_training_id, :dependent => :nullify, :on_update => :cascade

      t.timestamps
    end

    add_index :trainings, :trainee_id
    add_index :trainings, :original_training_id
    
  end
end
