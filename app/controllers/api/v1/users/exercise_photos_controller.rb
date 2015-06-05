class Api::V1::Users::ExercisePhotosController < ActionController::Base

  include AuthenticationHelper
  include UserExercisePhotoHelper

  def index
    when_signed_in do
      trainee = User.find_by_id(params[:user_id])
      @photos = exercise_photos_of(trainee, current_user)
      render 'api/v1/user_exercise_photos/index'
    end
  end
end