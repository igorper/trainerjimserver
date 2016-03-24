class AddExerciseTypeTranslations < ActiveRecord::Migration
  def change
    create_table :exercise_type_translations do |t|
      t.integer :exercise_type_id, :null => false
      t.string :language_code, :null => false
      t.string :name
      t.string :description

      t.timestamps
    end

    add_index :exercise_type_translations, :exercise_type_id
    add_index :exercise_type_translations, :language_code

    add_foreign_key :exercise_type_translations, :exercise_types, :column => :exercise_type_id, :on_delete => :cascade, :on_update => :cascade
  end
end
