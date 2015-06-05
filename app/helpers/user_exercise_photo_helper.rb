module UserExercisePhotoHelper
  def filter_exercise_photos_by_trainee(trainee, exercise_photos)
    if trainee.trainer.nil?
      exercise_photos.where('user_id = :id OR user_id IS NULL',
                            id: trainee.id)
    else
      exercise_photos.where('user_id = :id OR user_id = :trainer_id OR user_id IS NULL',
                            id: trainee.id, trainer_id: trainee.trainer.id)
    end
  end

  def exercise_photos_of(trainee, requestor)
    if requestor.id == trainee.id || (!trainee.trainer.nil? && trainee.trainer.id == requestor.id)
      filter_exercise_photos_by_trainee(trainee, UserExercisePhoto.all)
    else
      []
    end
  end
end
