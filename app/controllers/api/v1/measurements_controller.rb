class Api::V1::MeasurementsController < ActionController::Base

  def index
    if user_signed_in?
      @trainees = Measurement.where(trainee_id: current_user.id)
    else
      render status: :unauthorized
    end
  end

end