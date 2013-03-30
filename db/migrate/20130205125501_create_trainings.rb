class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.integer :trainee_id, :null => true
      t.string :name
      
      t.foreign_key :users, :column => :trainee_id, :dependent => :delete, :on_update => :cascade

      t.timestamps
    end

    add_index :trainings, :trainee_id
    
  end
end
