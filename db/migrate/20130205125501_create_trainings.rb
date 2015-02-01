class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.integer :trainee_id, :null => true
      t.string :name
      t.integer :original_training_id, :null => true
      

      t.timestamps
    end

    add_index :trainings, :trainee_id
    add_index :trainings, :original_training_id

    add_foreign_key :trainings, :users, :column => :trainee_id, :on_delete => :cascade, :on_update => :cascade
    add_foreign_key :trainings, :trainings, :column => :original_training_id, :on_delete => :nullify, :on_update => :cascade

  end

end
