class Api::V1::Trainees::TrainingsController < ActionController::Base

  include TrainingHelper

  def index
    if user_signed_in?
      trainings_of_trainee(params[:trainee_id])
    else
      render status: :unauthorized
    end
  end

  def show
    if user_signed_in?
      @training = Training.includes(:exercises => [:exercise_type, :series]).where(:id => params[:id]).first
      render 'api/v1/trainings/show'
    else
      render status: :unauthorized
    end
  end

  def trainings_of_trainee(trainee_id)
    if current_user.trainees.exists?(id: trainee_id)
      @training_list = Training.where(trainee_id: trainee_id)
    else
      render status: :unauthorized
    end
  end

end