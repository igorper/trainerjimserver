class Api::V1::Trainees::TraineeTrainingsController < ActionController::Base

  include TrainingHelper

  def index
    trainee_id = params[:trainee_id]
    if is_trainer_of?(trainee_id)
      @training_list = Training.where(trainee_id: trainee_id)
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
      edited_training = TrainingHelper.to_new_training(params)
      existing_training = Training.find_by(trainee_id: trainee_id, id: params[:id])
      @saved_training = save_training(edited_training, trainee_id, existing_training)
      render 'api/v1/trainings/create'
    else
      render status: :unauthorized
    end
  end

  def is_trainer_of?(trainee_id)
    user_signed_in? and current_user.trainees.exists?(id: trainee_id)
  end
end