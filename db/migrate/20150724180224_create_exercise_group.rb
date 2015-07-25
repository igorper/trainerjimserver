class CreateExerciseGroup < ActiveRecord::Migration
  def change
    create_table :exercise_groups do |t|
      t.string :name, null: false, unique: true
    end

    create_table :exercise_type_to_groups do |t|
      t.references :exercise_type, null: false
      t.references :exercise_group, null: false
    end

    add_index :exercise_type_to_groups, :exercise_type_id
    add_index :exercise_type_to_groups, :exercise_group_id

    add_foreign_key :exercise_type_to_groups, :exercise_types, column: :exercise_type_id, on_delete: :cascade, on_update: :cascade
    add_foreign_key :exercise_type_to_groups, :exercise_groups, column: :exercise_group_id, on_delete: :cascade, on_update: :cascade
  end
end
