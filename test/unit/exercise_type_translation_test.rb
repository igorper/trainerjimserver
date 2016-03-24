require 'test_helper'

class ExerciseTypeTranslationTest < ActiveSupport::TestCase
  test "returns translated the exercise types" do
    exercise_types_to_translate = ExerciseType.where(name: 'Super curl')
    translated_exercise_types = ExerciseTypeHelper.translate_exercise_type(exercise_types_to_translate, 'sl')
    assert_equal 'Trebušnjaki', translated_exercise_types[0].name
    assert_equal 'To so trebušnjaki.', translated_exercise_types[0].description
  end

  test "does not translate exercise type if it has no translation" do
    exercise_types_to_translate = ExerciseType.where(name: 'Bench press')
    translated_exercise_types = ExerciseTypeHelper.translate_exercise_type(exercise_types_to_translate, 'sl')
    assert_equal 'Bench press', translated_exercise_types[0].name
  end
end
