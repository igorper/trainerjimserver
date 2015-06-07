class Api::V1::UserExercisePhotosController < ActionController::Base

  include AuthenticationHelper
  include UserExercisePhotoHelper
  include ExerciseTypeHelper

  def destroy
    when_signed_in do
      user_exercise_photo = UserExercisePhoto.find_by_id(params[:id])
      if user_exercise_photo
        try_delete_user_exercise_photo(user_exercise_photo)
      else
        render status: :bad_request
      end
    end
  end

  def photos_of_user_and_exercise_type
    when_trainer_of(params[:user_id]) { |trainee|
      render_photos_of(trainee, params[:exercise_type_id])
    }
  end

  def add_photo
    when_signed_in do
      exercise_type = ExerciseType.find_by_id(params[:exercise_type_id])
      if exercise_type.nil?
        render status: :bad_request
      else
        user_id = params[:user_id].to_i
        if current_user.id == user_id || admin_or_trainer_of?(current_user, user_id)
          @photo = create_user_exercise_photo(user_id, exercise_type.id, params[:file])
        else
          render_unauthorized
        end
      end
    end
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
      render_photos_of(current_user, params[:exercise_type_id])
    end
  end

  private

  def create_user_exercise_photo(trainee_id, exercise_type_id, photo)
    UserExercisePhoto.create(
        user_id: trainee_id,
        exercise_type_id: exercise_type_id,
        photo: photo
    )
  end

  def render_photos_of(trainee, exercise_type_id)
    @photos = UserExercisePhoto.where(exercise_type_id: exercise_type_id)
    @photos = filter_exercise_photos_by_trainee(trainee, @photos)
    render 'api/v1/user_exercise_photos/index'
  end

  def try_delete_user_exercise_photo(user_exercise_photo)
    if admin_or_trainer_of?(current_user, user_exercise_photo.user_id)
      user_exercise_photo.delete
      true
    else
      false
    end
  end


end