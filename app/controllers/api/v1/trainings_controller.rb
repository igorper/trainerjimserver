class Api::V1::TrainingsController < ActionController::Base

  include TrainingHelper

  def index
    if user_signed_in?
      @training_list = active_trainings(Training.where(trainee_id: current_user.id))
    else
      render status: :unauthorized
    end
  end

  def show
    if user_signed_in?
      @training = full_trainings.find_by_id(params[:id])
      if @training.nil?
        ajax_error_i18n :training_does_not_exist
      elsif !@training.trainee_id.nil? && @training.trainee_id != current_user.id
        render json: {}, status: :forbidden
      end
    else
      render status: :unauthorized
    end
  end

  def create
    if user_signed_in?
      trainee_id = current_user.id
      edited_training = TrainingHelper.to_new_training(params)
      existing_training = Training.find_by(trainee_id: trainee_id, id: params[:id])
      @saved_training = save_training(edited_training, trainee_id, existing_training)
    else
      render status: :unauthorized
    end
  end

  def destroy
    if user_signed_in?
      archive_training_and_render(current_user.id, params[:id])
    else
      render status: :unauthorized
    end
  end
end