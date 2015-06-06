class Api::V1::Users::ExerciseTypes::PhotosController < ActionController::Base

  include AuthenticationHelper
  include ExerciseTypeHelper
  include UserExercisePhotoHelper

  def index
    when_trainer_of(params[:user_id]) { |trainee|
      @photos = UserExercisePhoto.where(exercise_type_id: params[:exercise_type_id])
      @photos = filter_exercise_photos_by_trainee(trainee, @photos)
      render 'api/v1/user_exercise_photos/index'
    }
  end

  def create
    when_trainer_of(params[:user_id]) { |trainee|
      exercise_type = current_user_exercise_types.find_by_id(params[:exercise_type_id])
      if exercise_type
        create_trainee_exercise_photo(trainee, exercise_type, params[:file])
        render json: {}
      else
        render_unauthorized
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