class MeasurementsController < ApplicationController
  
  def upload
    @measurement = MeasurementSubmission.new(params[:measurement_submission])
    @user = User.find_by_email @measurement.email
    if @user.present? and @user.authenticate(@measurement.password) then
      @measurement.user_id = @user.id
      # TODO: Maybe do something with the data (verify it, parse it... whatever).
      @measurement.data = @measurement.file_upload_data.read
      @measurement.save
      head :ok
    else
      head :bad_request
    end
  end

  # GET /measurements/new
  # GET /measurements/new.json
  def new
    @measurement = MeasurementSubmission.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @measurement }
    end
  end
end
