class Api::V1::TraineesController < ActionController::Base

  include AuthenticationHelper
  include ExerciseTypeHelper

  def index
    when_signed_in do
      @trainees = User.where(trainer_id: current_user.id)
    end
  end

  def create
    when_trainer do
      @trainee = User.create(
          email: params[:email],
          password: params[:email],
          full_name: params[:full_name],
          photo: params[:file],
          trainer: current_user
      )
      render :show
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
    when_signed_in do
      @trainee = User.find_by(id: params[:id], trainer_id: current_user.id)
    end
  end

end