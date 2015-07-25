class ExerciseType < ActiveRecord::Base
  has_many :user_exercise_photos
  has_many :exercises
  has_many :exercise_type_to_groups
  has_many :exercise_groups, through: :exercise_type_to_groups
end