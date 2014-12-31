class Api::V1::TrainingController < ActionController::Base

  def trainings
    if user_signed_in?
      @training_list = Training.where(:trainee_id => nil)
      render formats: ['json']
    else
      render json: {}, status: :unauthorized
    end
  end

  def training
    if user_signed_in?
      @training = Training.includes(:exercises => [:exercise_type, :series]).where(:id => params[:id]).first
      if @training.nil?
        ajax_error_i18n :training_does_not_exist
      elsif !@training.trainee_id.nil? && @training.trainee_id != current_user.id
        render :nothing => true, :status => :forbidden
      else
          render :json => @training.to_json(TrainingHelper.training_full_view)
      end
    else
      render json: {}, status: :unauthorized
    end
  end

  def exercises
    render :json => ExerciseType.all.to_json(TrainingHelper.exercise_type_view)
  end

end