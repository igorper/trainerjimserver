class Api::V1::TrainingsController < ActionController::Base

  def index
    if user_signed_in?
      @training_list = Training.where(:trainee_id => nil)
      render
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
      else
        render
      end
    else
      render json: {}, status: :unauthorized
    end
  end

  def create
    training = TrainingHelper.to_training(params)
    render
  end

end