class Api::V1::ExerciseGroupsController < ActionController::Base

  def index
    @exercise_groups = ExerciseGroup.all
    exercise_groups_latest_timestamp = @exercise_groups.maximum(:updated_at).try(:utc)
    fresh_when last_modified: exercise_groups_latest_timestamp,
               etag: "exercise_groups:index;timestamp:#{exercise_groups_latest_timestamp}",
               template: false
  end

end