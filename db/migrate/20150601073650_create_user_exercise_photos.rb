class CreateUserExercisePhotos < ActiveRecord::Migration
  def change
    create_table :user_exercise_photos do |t|
      t.references :user
      t.references :exercise_type
      t.attachment :photo
    end

    add_index :user_exercise_photos, :user_id
    add_index :user_exercise_photos, :exercise_type_id

    add_foreign_key :user_exercise_photos, :users, :column => :user_id, :on_delete => :cascade, :on_update => :cascade
    add_foreign_key :user_exercise_photos, :exercise_types, :column => :exercise_type_id, :on_delete => :cascade, :on_update => :cascade
  end
end
