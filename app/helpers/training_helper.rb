module TrainingHelper
  mattr_reader :series_view, :exercise_view, :training_view,
    :exercise_full_view, :training_full_view, :exercise_type_view


  # TODO: Stop using these json views and start using JBuilder views.

  ###############################################################################
  ### EXERCISE TYPE VIEWS
  ##
  
  # A JSON field include filter that contains only fields relevant to the end user.
  @@exercise_type_view = {:only => [:id, :name]}
  
  ###############################################################################
  ### SERIES VIEWS
  ##
  
  # Returns the JSON view filter for the Series model so as to include only
  # information required by the users (the browser).
  @@series_view = {:only => [:id, :repeat_count, :weight, :rest_time]}
  
  ###############################################################################
  ### EXERCISE VIEWS
  ##
  
  # A JSON field include filter that contains only fields relevant to the end user.
  @@exercise_view = {:only => [:id, :order, :machine_setting, :duration_after_repetition, :duration_up_repetition, :duration_middle_repetition, :duration_down_repetition, :guidance_type]}
  
  # Returns the JSON view filter for the Exercise model so as to include only
  # information required by the users (the browser).
  @@exercise_full_view = @@exercise_view.merge(:include => { :series => @@series_view, :exercise_type => @@exercise_type_view })
  
  ###############################################################################
  ### TRAINING VIEWS
  ##
  
  # A JSON field include filter that contains only fields relevant to the end user.
  @@training_view = {:only => [:id, :name, :updated_at]}
  
  # Returns the JSON view filter for the Training model so as to include only
  # information required by the users (the browser).
  @@training_full_view = @@training_view.merge(:include => { :exercises => @@exercise_full_view })
  
  ###############################################################################
  ### HELPER METHODS
  ##
  
  # Saves the given training (in JSON form) as the user's new training.
  # This method also assigns the original training to the new training, if
  # original is given.
  #
  # @return the newly saved training
  def save_new_training(training_json, original_training = nil)
    new_training = training_from_json(training_json)
    if original_training
      new_training.original_training = original_training
    end
    new_training.trainee_id = current_user.id
    new_training.save
    return new_training
  end
  
  # Modifies the given training with the new information
  def save_edited_training(training_json, original_training)
    # Edit training details
    original_training.name = training_json['name']
    original_training.exercises.clear
    add_exercises_from_json(training_json['exercises'], original_training)
    original_training.save
    return original_training
  end
  
  # @return   a training model that contains all the info from the given JSON.
  #           the new training is not stored into the DB.
  def training_from_json(training_json)
    new_training = Training.new()
    new_training.name = training_json['name']
    add_exercises_from_json(training_json['exercises'], new_training)
    return new_training
  end
  
  def add_exercises_from_json(exercises_json, to_training)
    order = 0
    exercises_json.each { |ex| 
      ex['order'] = order
      exercise_from_json(ex, to_training)
      order = order + 100
    }
  end
  
  # @return   a new exercise model associated to the parent training.
  def exercise_from_json(exercise_json, parent_training)
    new_exercise = parent_training.exercises.build()
    add_series_from_json(exercise_json['series'], new_exercise)
    new_exercise.exercise_type = ExerciseType.find_by_id(exercise_json['exercise_type']['id'])
    new_exercise.guidance_type = exercise_json['guidance_type']
    new_exercise.duration_after_repetition = exercise_json['duration_after_repetition']
    new_exercise.duration_up_repetition = exercise_json['duration_up_repetition']
    new_exercise.duration_middle_repetition = exercise_json['duration_middle_repetition']
    new_exercise.duration_down_repetition = exercise_json['duration_down_repetition']
    new_exercise.machine_setting = exercise_json['machine_setting']
    return new_exercise
  end
  
  def add_series_from_json(series_json, to_exercise)
    order = 0
    series_json.each { |serie|
      serie['order'] = order
      series_from_json(serie, to_exercise)
      order = order + 100
    }
  end
  
  # @return   a new serie model associated to the parent exercise.
  def series_from_json(serie_json, parent_exercise)
    serie_params = ActionController::Parameters.new(serie_json)
    return parent_exercise.series.build(serie_params.permit(
      :order,
      :repeat_count,
      :weight,
      :rest_time
    ))
  end
  
  # @param  training    the training we want to copy (must be a [[Training]] instance).
  # @param  user        the user who should own this training (the trainee).
  # @return a copy of the given training
  def clone_training_for_user(training, user)
    new_training = training.dup
    new_training.trainee = user
    new_training.original_training = training
    # Add exercises to the training:
    training.exercises.each do |ex|
      new_ex = ex.dup
      # Add series to the training's exercises:
      ex.series.each do |s|
        new_s = s.dup
        new_ex.series << new_s
      end
      new_training.exercises << new_ex
    end
    
    return new_training.save
  end
end
