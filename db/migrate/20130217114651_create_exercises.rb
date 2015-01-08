class CreateExercises < ActiveRecord::Migration
  def change

    create_table :exercises do |t|
      t.references :training, :null => false
      t.references :exercise_type, :null => false
      t.integer :order

      t.timestamps
    end

    add_index :exercises, :training_id
    add_index :exercises, :exercise_type_id

    add_foreign_key :exercises, :trainings, :column => :training_id, :on_delete => :cascade, :on_update => :cascade
    add_foreign_key :exercises, :exercise_types, :column => :exercise_type_id, :on_delete => :cascade, :on_update => :cascade
  end
end
