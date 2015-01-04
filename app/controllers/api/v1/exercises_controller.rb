class Api::V1::ExercisesController < ActionController::Base

  def index
    render :json => ExerciseType.all.to_json(TrainingHelper.exercise_type_view)
  end

end