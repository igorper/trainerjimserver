# == Schema Information
#
# Table name: trainings
#
#  id                   :integer          not null, primary key
#  trainee_id           :integer
#  name                 :string(255)
#  original_training_id :integer
#  created_at           :datetime
#  updated_at           :datetime
#

require 'test_helper'

class TrainingTest < ActiveSupport::TestCase
  
  test "Training Trainee" do
    t = trainings(:matej1)
    assert !t.nil?
    assert !t.trainee.nil?
    assert t.trainee.display_name == users(:matej).display_name
  end
end
