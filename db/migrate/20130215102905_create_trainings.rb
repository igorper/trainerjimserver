class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.integer :user_id, :null => false
      t.integer :trainer_id
      t.string :name

      t.foreign_key :users, :column => 'user_id', :dependent => :delete, :on_update => :cascade
      t.foreign_key :users, :column => 'trainer_id', :dependent => :nullify, :on_update => :cascade
      
      t.timestamps
    end

    add_index :trainings, :user_id
    add_index :trainings, :trainer_id
    
  end
end
