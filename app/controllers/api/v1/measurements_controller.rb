class Api::V1::MeasurementsController < ActionController::Base

  def index
    if user_signed_in?
      @measurements = Measurement.includes(:training).where(trainee_id: current_user.id)
    else
      render status: :unauthorized
    end
  end

  def show
    if user_signed_in?
      @measurement = Measurement.includes(:series_executions, :training).where(:id => params[:id]).first
      if @measurement.nil?
        ajax_error_i18n :measurement_does_not_exist
      elsif @measurement.trainee_id != current_user.id
        render json: {}, status: :forbidden
      end
    else
      render json: {}, status: :unauthorized
    end
  end

end