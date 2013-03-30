class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.integer :trainee_id, :null => false
      t.integer :trainer_id, :null => false
      t.belongs_to :training, :null => false
      t.binary :data
      t.timestamp :start_time
      t.timestamp :end_time
      t.integer :rating

      t.foreign_key :trainings, :column => :training_id, :dependent => :delete, :on_update => :cascade
      t.foreign_key :users, :column => :trainee_id, :dependent => :delete, :on_update => :cascade
      t.foreign_key :users, :column => :trainer_id, :dependent => :nullify, :on_update => :cascade

      t.timestamps
    end
    
    add_index :measurements, :training_id
    add_index :measurements, :trainee_id
    add_index :measurements, :trainer_id
  end
end
