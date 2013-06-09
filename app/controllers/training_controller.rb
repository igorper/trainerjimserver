class TrainingController < ApplicationController
  
  include AjaxHelper
  include TrainingHelper
  
  # Shows the workout selection and building page 
  def workouts
    if !user_signed_in?
      redirect_to welcome_url
    end
  end
  
  # Returns the list of global training templates (provided for all users).
  # 
  # @returns a list of training templates (view: `TrainingHelper.training_view`).
  #
  # @formats json
  def templates
    @global_trainings = Training.find_all_by_trainee_id(nil)
    respond_to do |f|
      f.json {render :json => @global_trainings.to_json(TrainingHelper.training_view)}
    end
  end
  
  # @param workout    A JSON `training` object:
  #                   {
  #                     id - the ID of the training this one is based on.
  #                   }
  def save_workout
    if user_signed_in?
      the_workout = ActiveSupport::JSON.decode(params['workout'])
      respond_to do |f|
        # The user can edit an existing workout. If the existing workout belongs
        # to them, it will be changed. If it does not belong to them (if it is
        # a common one), then a duplicate has to be created.
        existing_training = Training.find_by_id(the_workout['id'])
        if existing_training
          if existing_training.common?
            # Save new training based on another one:
            f.json {render :json => save_new_training(the_workout, existing_training)}
          else
            f.json {render :json => "Saving an own training."}
          end
        else
          f.json {render :json => "Saving a new training."}
        end
      end
    else
      respond_to do |f|
        f.json {ajax_error_i18n :user_not_logged_in}
      end
    end
  end
  
  # Returns the list of the user's own training regimes.
  # 
  # @returns a list of training templates (view: `TrainingHelper.training_view`).
  #
  # @formats json
  def my_templates
    if user_signed_in?
      @global_trainings = Training.find_all_by_trainee_id(current_user.id)
      respond_to do |f|
        f.json {render :json => @global_trainings.to_json(TrainingHelper.training_view)}
      end
    else
      respond_to do |f|
        f.json {ajax_error_i18n :user_not_logged_in}
      end
    end
  end
  
  # Returns a full specification of the training template. If the requested
  # training template belongs to a user, it will be checked that the current user
  # is the owner.
  # 
  # @param id the id of the training template
  # 
  # @returns the full specification of a single training template (view: `TrainingHelper.training_view`).
  #
  # @formats json
  def my_template
    if user_signed_in?
      @training = Training.includes(:exercises => [:exercise_type, :series]).where(:id => params[:id]).first
      if @training.nil?
        ajax_error_i18n :training_does_not_exist
      elsif !@training.trainee_id.nil? && @training.trainee_id != current_user.id
        ajax_error_i18n :training_belongs_to_someone_else
      else
        respond_to do |f|
          f.json {render :json => @training.to_json(TrainingHelper.training_full_view)}
        end
      end
    end
  end
  
  # @returns all currently known exercise types.
  #
  # @formats json
  def exercise_types
    respond_to do |f|
      f.json {render :json => ExerciseType.all.to_json(TrainingHelper.exercise_type_view)}
    end
  end
  
  # Returns an entire training for the user.
  # @method POST, GET
  # @param email 
  # @param password
  # @param id
  # @returns JSON a JSON encoded string containing the first training (together
  # with its exercises and series).
  def m_get
    with_auth_mapi do |user|
      ajax_render Training.find_by_id(params[:id], :include => [:exercises, {:exercises => :series}]).to_json(TrainingHelper.training_full_view)
    end
  end
  
  # Lists all trainings for the current user
  # @method POST, GET
  # @param email 
  # @param password
  # @returns JSON a JSON encoded list all trainings
  def m_list
    with_auth_mapi do |user|
      ajax_render Training.all.to_json(TrainingHelper.training_view)
    end
  end
  
  # Receives and stores a training measurement session from the mobile app.
  # 
  # @param email
  # @param password
  # @param trainingData [ZIP FILE] a binary stream of data. Should contain files:
  #                     - `training`
  #                     - `raw`.
  # @return the ID of the newly created measurement.
  def m_upload
    with_auth_mapi do |user|
      require 'zip/zipfilesystem'
      # Get the zip file that is the training data:
      Zip::ZipFile.open(params[:trainingData].path) do |zip_file|
        
        training_info = nil
        raw_measurements = nil
        
        # Get all the data from the ZIP
        zip_file.each do |file|
          if file.name == 'training' then
            training_info = ActiveSupport::JSON.decode(file.get_input_stream.read)
            #            data.push({:name => file.name, :size => file.size, :compressed_size => file.compressed_size, :contents => file.get_input_stream.read})
          elsif file.name == 'raw' then
            raw_measurements = file.get_input_stream.read
          else
            # There are some unknown files in the zip. Report this error.
            ajax_error :unknown_data_in_archive
            return
          end
        end
        
        # Check whether we actually got the data:
        if training_info.nil? || raw_measurements.nil? then
          # We didn't get all the data. Throw an error: 
          ajax_error :some_measurement_data_missing
        else
          measurement = Measurement.new(
            :data => raw_measurements,
            :trainee => user,
            :start_time => training_info['start_time'],
            :end_time => training_info['end_time'],
            :rating => training_info['rating'],
            :comment => training_info['comment']
          )
          measurement.training_id = training_info['training_id']
          measurement.trainer = user.trainer
          
          training_info['series_executions'].each do |se|
            
            new_se = SeriesExecution.new(
              :start_timestamp => se['start_timestamp'],
              :end_timestamp => se['end_timestamp'],
              :exercise_type_id => se['exercise_type_id'],
              :num_repetitions => se['num_repetitions'],
              :weight => se['weight'],
              :rest_time => se['rest_time'],
              :duration_seconds => se['duration']
            )
            measurement.series_executions << new_se
          end
        
          measurement.save!
          ajax_render measurement.id
        end
        
      end
    end
  end
  
  def tests
    #    ajax_render clone_training_for_user(Training.find_by_id(1, :include => [:exercises, {:exercises => [:series, :exercise_type]}]), User.find_by_email('matej.urbas@gmail.com')).to_json(TrainingHelper.training_full_view)
    #    ajax_render Training.find_by_id(1, :include => [:exercises, {:exercises => [:series, :exercise_type]}]).to_json(TrainingHelper.training_full_view)
  end
end
