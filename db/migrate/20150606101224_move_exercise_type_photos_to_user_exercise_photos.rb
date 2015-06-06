class MoveExerciseTypePhotosToUserExercisePhotos < ActiveRecord::Migration
  def self.up
    ExerciseType.all.each { |exercise_type|
      say("Moving photo of exercise type #{exercise_type.id} (name: #{exercise_type.name}) to UserExercisePhoto...")
      user_exercise_photo = UserExercisePhoto.create(
          user_id: exercise_type.owner_id,
          exercise_type_id: exercise_type.id,
          photo: exercise_type.image
      )
      user_exercise_photo.save
      say("UserExercisePhoto #{user_exercise_photo.id} created.")
    }
  end
end
