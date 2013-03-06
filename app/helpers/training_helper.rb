module TrainingHelper
  mattr_reader :series_view, :exercise_view, :training_view, :exercise_full_view, :training_full_view
  
  # Returns the JSON view filter for the Series model so as to include only
  # information required by the users (the browser).
  @@series_view = { :only => [:id, :repeat_count, :weight, :rest_time] }
  # A JSON field include filter that contains only fields relevant to the end user.
  @@exercise_view = {:only => [:id, :name]}
  # A JSON field include filter that contains only fields relevant to the end user.
  @@training_view = {:only => [:id, :name]}
  # Returns the JSON view filter for the Exercise model so as to include only
  # information required by the users (the browser).
  @@exercise_full_view = @@exercise_view.merge(:include => { :series => @@series_view })
  # Returns the JSON view filter for the Training model so as to include only
  # information required by the users (the browser).
  @@training_full_view = @@training_view.merge(:include => { :exercises => @@exercise_full_view })
end
