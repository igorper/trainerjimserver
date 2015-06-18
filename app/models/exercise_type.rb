class ExerciseType < ActiveRecord::Base
  has_many :user_exercise_photos
  has_many :exercises
end