class Api::V1::Users::ExerciseTypes::PhotosController < ActionController::Base

  include AuthenticationHelper
  include ExerciseTypeHelper

  def index
    when_trainer_of(params[:user_id]) { |trainee|
      @exercise_photos = UserExercisePhoto.where(exercise_type_id: params[:exercise_type_id])
      if trainee.trainer.nil?
        @exercise_photos = @exercise_photos.where('user_id = :id OR user_id IS NULL',
                                                  id: trainee.id)
      else
        @exercise_photos = @exercise_photos.where('user_id = :id OR user_id = :trainer_id OR user_id IS NULL',
                                                  id: trainee.id, trainer_id: trainee.trainer.id)
      end
    }
  end

  def create
    when_trainer_of(params[:user_id]) { |trainee|
      exercise_type = current_user_exercise_types.find_by_id(params[:exercise_type_id])
      if exercise_type
        create_trainee_exercise_photo(trainee, exercise_type, params[:file])
        render json: {}
      else
        render json: {}, status: :unauthorized
      end
    }
  end

  private
  def create_trainee_exercise_photo(trainee, exercise_type, photo)
    UserExercisePhoto.create(
        user_id: trainee.id,
        exercise_type_id: exercise_type.id,
        photo: photo
    )
  end

end