class Api::V1::Trainees::TraineeTrainingsController < ActionController::Base

  include TrainingHelper

  def index
    trainee_id = params[:trainee_id]
    if is_trainer_of?(trainee_id)
      @training_list = active_trainings(Training.where(trainee_id: trainee_id))
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

  def create
    trainee_id = params[:trainee_id]
    if is_trainer_of?(trainee_id)
      save_training_and_render(trainee_id, params[:id])
    else
      render status: :unauthorized
    end
  end

  def destroy
    trainee_id = params[:trainee_id]
    if is_trainer_of?(trainee_id)
      archive_training_and_render(trainee_id, params[:id])
    else
      render status: :unauthorized
    end
  end

  def is_trainer_of?(trainee_id)
    user_signed_in? and current_user.trainees.exists?(id: trainee_id)
  end
end