class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.integer :user_id, :null => false
      t.integer :trainer_id
      t.string :name

      t.foreign_key :users, :column => 'user_id', :dependent => :delete
      t.foreign_key :users, :column => 'trainer_id', :dependent => :nullify
      
      t.timestamps
    end
    
    change_table :trainings do |t|
      t.index  :user_id
      t.index  :trainer_id
    end
    
  end
end
