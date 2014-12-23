class Api::V1::TrainingController < ActionController::Base

  def trainings
    if user_signed_in?
      @training_list = Training.where(:trainee_id => nil)
      render formats: ['json']
    else
      render json: {}, status: :unauthorized
    end
  end

end