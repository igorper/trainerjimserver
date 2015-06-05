class Api::V1::Users::Trainings::ExercisePhotosController < ActionController::Base

  include AuthenticationHelper
  include UserExercisePhotoHelper

  def index
    when_trainer_of(params[:user_id]) { |trainee|
      @photos = UserExercisePhoto
                    .joins(exercise_type: [{exercises: [:training]}])
                    .where('trainings.trainee_id' => params[:user_id], 'trainings.id' => params[:training_id])
      @photos = filter_exercise_photos_by_trainee(trainee, @photos)
      render 'api/v1/user_exercise_photos/index'
    }
  end
end