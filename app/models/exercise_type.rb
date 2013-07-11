# == Schema Information
#
# Table name: exercise_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class ExerciseType < ActiveRecord::Base
  # attr_accessible :name
end
