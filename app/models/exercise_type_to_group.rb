class ExerciseTypeToGroup < ActiveRecord::Base
  belongs_to :exercise_type
  belongs_to :exercise_group
end