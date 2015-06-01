class Api::V1::TraineesController < ActionController::Base

  include AuthenticationHelper

  def index
    if user_signed_in?
      @trainees = User.where(trainer_id: current_user.id)
    else
      render json: {}, status: :unauthorized
    end
  end

  def photo
    when_trainer_of(params[:id]) { |trainee|
      trainee.photo = params[:file]
      trainee.save
      @trainee = trainee
    }
  end

  def add_exercise_photo
    when_trainer_of(params[:id]) { |trainee|
      exercise_type = ExerciseType.where(owner_id: current_user.id, id: params[:exercise_type_id]).first
      if exercise_type
        create_trainee_exercise_photo(trainee, exercise_type, params[:photo])
        render json: {}
      else
        render json: {}, status: :unauthorized
      end
    }
  end

  def show
    if user_signed_in?
      @trainee = User.find_by(id: params[:id], trainer_id: current_user.id)
    else
      render json: {}, status: :unauthorized
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

end