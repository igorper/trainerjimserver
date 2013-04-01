class TrainingController < ApplicationController
  
  include AjaxHelper
  include TrainingHelper
  
  def workouts
  end
  
  def show
    @t = Training.find_by_id(params[:id])
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
  
  # @param email
  # @param password
  # @param trainingData [ZIP FILE] a binary stream of data. Should contain files `training` and `raw`.
  # TODO: define ZIP FILE contents.
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
            ajax_render_symerr :unknown_data_in_archive
            return
          end
        end
        
        # Check whether we actually got the data:
        if training_info.nil? || raw_measurements.nil? then
          # We didn't get all the data. Throw an error: 
          ajax_render_symerr :some_measurement_data_missing
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
          measurement.trainer_id = training_info['trainer_id']
          
          training_info['series_executions'].each do |se|
            
            # TODO: Igor should pass the exercise type rather than the exercise ID.
            assoc_ex = Exercise.find_by_id(se['exercise_id'])
            if assoc_ex
              ex_type = assoc_ex.exercise_type
            else
              ex_type = ExerciseType.first
            end
            
            new_se = SeriesExecution.new(
              :start_timestamp => se['start_timestamp'],
              :end_timestamp => se['end_timestamp'],
              :exercise_type => ex_type,
              :num_repetitions => se['num_repetitions'],
              :weight => se['weight'],
              :rest_time => se['rest_time'],
              :duration_seconds => se['duration']
            )
            measurement.series_executions << new_se
          end
        
          #          ajax_render training_info
          measurement.save!
          ajax_render measurement.to_json(:include => :series_executions)
        end
        
      end
    end
  end
  
  def tests
    #    ajax_render clone_training_for_user(Training.find_by_id(1, :include => [:exercises, {:exercises => [:series, :exercise_type]}]), User.find_by_email('matej.urbas@gmail.com')).to_json(TrainingHelper.training_full_view)
    #    ajax_render Training.find_by_id(1, :include => [:exercises, {:exercises => [:series, :exercise_type]}]).to_json(TrainingHelper.training_full_view)
  end
end
