class Api::V1::MeasurementsController < ActionController::Base

  def index
    if user_signed_in?
      if params[:trainer].present? && params[:trainer] == "true"
        if params[:trainee_id].present?
          # show measurements for a particular trainee
          @measurements = Measurement.includes(:training).where(trainee_id: params[:trainee_id])
        else
          # show current user's measurements
          @measurements = Measurement.includes(:training).where(trainee_id: current_user.id)
        end
      else
        # show current user's measurements
        @measurements = Measurement.includes(:training).where(trainee_id: current_user.id)
      end

    else
      render status: :unauthorized
    end
  end

  def show
    if user_signed_in?
      @measurement = Measurement.includes(:series_executions, :training).where(:id => params[:id]).first
      if @measurement.nil?
        ajax_error_i18n :measurement_does_not_exist
      elsif @measurement.trainer_id != current_user.id && @measurement.trainee_id != current_user.id
        render json: {}, status: :forbidden
      end
    else
      render json: {}, status: :unauthorized
    end
  end

end