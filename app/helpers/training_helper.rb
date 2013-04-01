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
  ### CLONING TRAININGS FOR USERS
  ##
  def clone_training_for_user(training, user)
    new_training = training.dup
    new_training.trainee = user
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
