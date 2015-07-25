class ExerciseGroup < ActiveRecord::Base
  has_many :exercise_type_to_groups
  has_many :exercise_types, through: :exercise_type_to_groups
end