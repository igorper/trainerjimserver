class Api::V1::ExerciseGroupsController < ActionController::Base

  def index
    @exercise_groups = ExerciseGroup.all
  end

end