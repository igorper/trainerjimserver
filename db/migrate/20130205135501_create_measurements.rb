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

      t.timestamps
    end

    add_index :measurements, :training_id
    add_index :measurements, :trainee_id
    add_index :measurements, :trainer_id

    add_foreign_key :measurements, :trainings, :column => :training_id, :on_delete => :cascade, :on_update => :cascade
    add_foreign_key :measurements, :users, :column => :trainee_id, :on_delete => :cascade, :on_update => :cascade
    add_foreign_key :measurements, :users, :column => :trainer_id, :on_delete => :nullify, :on_update => :cascade
  end
end
