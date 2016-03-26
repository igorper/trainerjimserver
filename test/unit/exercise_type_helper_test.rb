require 'test_helper'

class ExerciseTypeHelperTest < ActiveSupport::TestCase
  test "returns translated the exercise types" do
    exercise_types = ExerciseType.where(name: 'Super curl')
    translations = ExerciseTypeHelper.get_translations(exercise_types, 'sl')
    translated_exercise_types = ExerciseTypeHelper.translate_all(exercise_types, translations)
    assert_equal 'Trebušnjaki', translated_exercise_types[0].name
    assert_equal 'To so trebušnjaki.', translated_exercise_types[0].description
  end

  test "does not translate exercise type if it has no translation" do
    exercise_types = ExerciseType.where(name: 'Bench press')
    translations = ExerciseTypeHelper.get_translations(exercise_types, 'sl')
    translated_exercise_types = ExerciseTypeHelper.translate_all(exercise_types, translations)
    assert_equal 'Bench press', translated_exercise_types[0].name
  end

  test "returns translation for the single exercise type" do
    exercise_type = ExerciseType.find_by_name('Super curl')
    translation = ExerciseTypeHelper.get_translation(exercise_type, 'sl')
    translated_exercise_type = ExerciseTypeHelper.translate(exercise_type, translation)
    assert_equal 'Trebušnjaki', translated_exercise_type.name
    assert_equal 'To so trebušnjaki.', translated_exercise_type.description
  end
end
