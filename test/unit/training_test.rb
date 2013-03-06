require 'test_helper'

class TrainingTest < ActiveSupport::TestCase
  test "Training Trainee" do
    t = trainings(:matej1)
    assert !t.nil?
    assert !t.trainee.nil?
    assert t.trainee.display_name == users(:matej).display_name
  end
end
