class ExerciseTypeTranslation < ActiveRecord::Base
  belongs_to :exercise_type, class_name: :ExerciseType, foreign_key: :exercise_type_id
end
