class Api::V1::Trainees::TraineeTrainingsController < ActionController::Base

  include TrainingHelper

  def index
    if user_signed_in? and current_user.trainees.exists?(id: params[:trainee_id])
      @training_list = Training.where(trainee_id: params[:trainee_id])
      render 'api/v1/trainings/index' and return
    end
    render status: :unauthorized
  end

  def show
    if user_signed_in?
      @training = full_trainings.find_by_id(params[:id])
      if @training.trainee.trainer == current_user
        render 'api/v1/trainings/show' and return
      end
    end
    render status: :unauthorized
  end
end