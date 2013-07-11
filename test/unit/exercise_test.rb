# == Schema Information
#
# Table name: exercises
#
#  id               :integer          not null, primary key
#  training_id      :integer          not null
#  exercise_type_id :integer          not null
#  order            :integer
#  created_at       :datetime
#  updated_at       :datetime
#  machine_setting  :string(255)
#

require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
