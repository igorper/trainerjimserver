class Api::V1::ExerciseGroupsController < ActionController::Base

  def index
    @exercise_groups = ExerciseGroup.all
    fresh_when last_modified: @exercise_groups.maximum(:updated_at).try(:utc),
               etag: "exercise_groups:index",
               template: false
  end

end