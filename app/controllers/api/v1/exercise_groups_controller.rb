class Api::V1::ExerciseGroupsController < ActionController::Base

  include ConditionalRenderHelper

  def index
    @exercise_groups = ExerciseGroup.all
    conditional_render(@exercise_groups, 'exercise_groups:index')
  end

end