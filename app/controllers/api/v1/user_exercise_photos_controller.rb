class Api::V1::UserExercisePhotosController < ActionController::Base

  include AuthenticationHelper
  include UserExercisePhotoHelper
  include ExerciseTypeHelper

  def destroy
    when_signed_in do
      exercise_type = UserExercisePhoto.find_by_id(params[:id])
      if exercise_type
        when_trainer_of(exercise_type.user_id) { |_|
          exercise_type.delete
        }
      else
        render status: :bad_request
      end
    end
  end

  def photos_of_user_and_exercise_type
    when_trainer_of(params[:user_id]) { |trainee|
      render_exercise_photos(trainee, params[:exercise_type_id])
    }
  end

  def add_photo
    when_trainer_of(params[:user_id]) { |trainee|
      exercise_type = trainer_trainee_exercise_types(trainee, current_user).find_by_id(params[:exercise_type_id])
      if exercise_type
        @photo = create_trainee_exercise_photo(trainee, exercise_type, params[:file])
      else
        render_unauthorized
      end
    }
  end

  def trainer_trainee_exercise_types(trainee, current_user)
    ExerciseType.where(
        'owner_id = :trainee_id OR owner_id = :trainer_id OR owner_id IS NULL',
        {trainee_id: trainee.id, trainer_id: current_user.id}
    )
  end

  def user_exercise_photos
    when_signed_in do
      trainee = User.find_by_id(params[:user_id])
      @photos = exercise_photos_of(trainee, current_user)
      render 'api/v1/user_exercise_photos/index'
    end
  end

  def user_training_photos
    when_trainer_of(params[:user_id]) { |trainee|
      @photos = UserExercisePhoto
                    .joins(exercise_type: [{exercises: [:training]}])
                    .where('trainings.trainee_id' => params[:user_id], 'trainings.id' => params[:training_id])
                    .uniq
      @photos = filter_exercise_photos_by_trainee(trainee, @photos)
      render 'api/v1/user_exercise_photos/index'
    }
  end

  def photos_of_current_user
    when_signed_in do
      render_exercise_photos(current_user, params[:exercise_type_id])
    end
  end

  private
  def create_trainee_exercise_photo(trainee, exercise_type, photo)
    UserExercisePhoto.create(
        user_id: trainee.id,
        exercise_type_id: exercise_type.id,
        photo: photo
    )
  end

  private
  def render_exercise_photos(trainee, exercise_type_id)
    @photos = UserExercisePhoto.where(exercise_type_id: exercise_type_id)
    @photos = filter_exercise_photos_by_trainee(trainee, @photos)
    render 'api/v1/user_exercise_photos/index'
  end

end