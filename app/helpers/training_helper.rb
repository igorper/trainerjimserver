module TrainingHelper
  mattr_reader :series_view, :exercise_view, :training_view,
    :exercise_full_view, :training_full_view, :exercise_type_view
  
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
  @@exercise_view = {:only => [:id, :order]}
  
  # Returns the JSON view filter for the Exercise model so as to include only
  # information required by the users (the browser).
  @@exercise_full_view = @@exercise_view.merge(:include => { :series => @@series_view, :exercise_type => @@exercise_type_view })
  
  ###############################################################################
  ### TRAINING VIEWS
  ##
  
  # A JSON field include filter that contains only fields relevant to the end user.
  @@training_view = {:only => [:id, :name]}
  
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
  
  def save_edited_training(training_json, original_training)
    # Edit training details
    original_training.name = training_json['name']
    original_training.save
    return original_training
  end
  
  # @return   a training model that contains all the info from the given JSON.
  #           the new training is not stored into the DB.
  def training_from_json(training_json)
    new_training = Training.new()
    new_training.name = training_json['name']
    training_json['exercises'].each { |ex| exercise_from_json(ex, new_training) }
    return new_training
  end
  
  def exercise_from_json(exercise_json, parent_training)
    new_exercise = parent_training.exercises.build()
    exercise_json['series'].each { |serie| series_from_json(serie, new_exercise) }
    new_exercise.exercise_type = ExerciseType.find_by_id(exercise_json['exercise_type']['id'])
    return new_exercise
  end
  
  def series_from_json(serie_json, parent_exercise)
    return parent_exercise.series.build(serie_json)
  end
  
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
