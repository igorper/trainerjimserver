module TrainingHelper
  mattr_reader :series_view, :exercise_view, :training_view,
    :exercise_full_view, :training_full_view, :exercise_type_view

  def self.to_new_training(params)
    filtered_params = params.permit(:name)
    filtered_params[:exercises] = params[:exercises].map.with_index do |exercise_params, i|
      exercise_params[:order] = i
      ExerciseHelper.to_new_exercise(exercise_params)
    end
    Training.new(filtered_params)
  end

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
  # This method also assigns the original training to the new training, if the
  # original is given.
  #
  # @return the newly saved training
  def save_new_training(edited_training, original_training = nil)
    if original_training
      edited_training.original_training = original_training
    end
    edited_training.trainee_id = current_user.id
    edited_training.save
    edited_training
  end

  def save_edited_training(edited_training, original_training)
    edited_training.id = original_training.id
    original_training.delete
    save_new_training(edited_training)
  end

  def full_trainings
    Training.includes(exercises: [:exercise_type, :series])
  end

end
