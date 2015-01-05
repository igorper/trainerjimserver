class Api::V1::ExerciseTypesController < ActionController::Base

  def index
    @exercise_types = ExerciseType.all
  end

end