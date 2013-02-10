class MeasurementSubmission < Measurement
  attr_accessor :email, :password, :file_upload_data
  attr_accessible :email, :password, :file_upload_data
end
  
class MeasurementsController < ApplicationController
  
  
  def upload
    @measurement = MeasurementSubmission.new(params[:measurement_submission])
    # Did we get all the data and authorisation tokens needed for submission?
    if @measurement.email.present? and @measurement.file_upload_data.present? then
      # Good, now authenticate the user.
      @user = User.find_by_email @measurement.email
      if @user.present? and @user.authenticate(@measurement.password) then
        @measurement.user_id = @user.id
        # Everything is alright. Upload the data into the DB:
        # TODO: Maybe do something with the data (verify it, parse it... whatever).
        @measurement.data = @measurement.file_upload_data.read
        @measurement.save
        head :ok
        return
      end
    end
    head :bad_request
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
  
  def show
    @totalCount = Measurement.count
    @entriesPerPage = 30
    @totalPages = (@totalCount.to_f / @entriesPerPage).ceil
    @page = [[params[:page].present? ? params[:page].to_i : 1, @totalPages].min, 1].max
    @measurements = Measurement.offset((@page - 1) * @entriesPerPage).limit(@entriesPerPage)
  end
end
