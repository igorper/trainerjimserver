require 'test_helper'

class TrainingHelperTest < ActiveSupport::TestCase
  test "returns all exercise types in the training" do
    exercise_types = TrainingHelper.extract_exercise_types(trainings(:big_training))
    assert_equal exercise_types(:bench, :leg), exercise_types
  end

  test "translates exercise types in the training" do
    training = TrainingHelper.translate_exercise_types!(trainings(:curl_training), 'sl')
    assert_equal exercise_type_translations(:curl_sl).name,
                 training.exercises[0].exercise_type.name
  end
end
