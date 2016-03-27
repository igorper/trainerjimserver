class Api::V1::TrainingsController < ActionController::Base

  include AuthenticationHelper
  include TrainingHelper

  def index
    when_signed_in do
      @training_list = active_trainings(Training.where(trainee_id: current_user.id))
    end
  end

  def show
    when_signed_in do
      @training = full_trainings.find_by_id(params[:id])
      if @training.nil?
        render_not_found
      elsif !@training.trainee_id.nil? && @training.trainee_id != current_user.id
        render_forbidden
      end
      @training = TrainingHelper.translate_exercise_types!(@training, params[:language])
    end
  end

  def create
    when_signed_in do
      save_training_and_render(current_user.id, params[:id])
    end
  end

  def destroy
    when_signed_in do
      archive_training_and_render(current_user.id, params[:id])
    end
  end
end