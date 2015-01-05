class Api::V1::TrainingsController < ActionController::Base

  include TrainingHelper

  def index
    if user_signed_in?
      @training_list = Training.where('trainee_id is NULL OR trainee_id = ?', current_user.id)
    else
      render status: :unauthorized
    end
  end

  def show
    if user_signed_in?
      @training = Training.includes(:exercises => [:exercise_type, :series]).where(:id => params[:id]).first
      if @training.nil?
        ajax_error_i18n :training_does_not_exist
      elsif !@training.trainee_id.nil? && @training.trainee_id != current_user.id
        render json: {}, status: :forbidden
      end
    else
      render json: {}, status: :unauthorized
    end
  end

  def create
    if user_signed_in?
      edited_training = TrainingHelper.to_new_training(params)
      existing_training = Training.find_by_id(params[:id])
      if existing_training
        if existing_training.common?
          @saved_training = save_new_training(edited_training, existing_training)
        else
          @saved_training = save_edited_training(edited_training, existing_training)
        end
      else
        @saved_training = save_new_training(edited_training)
      end
    else
      render status: :unauthorized
    end
  end

end