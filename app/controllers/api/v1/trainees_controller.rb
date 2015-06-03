class Api::V1::TraineesController < ActionController::Base

  include AuthenticationHelper
  include ExerciseTypeHelper

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

  def show
    if user_signed_in?
      @trainee = User.find_by(id: params[:id], trainer_id: current_user.id)
    else
      render json: {}, status: :unauthorized
    end
  end

end