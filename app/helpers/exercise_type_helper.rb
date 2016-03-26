module ExerciseTypeHelper
  def current_user_exercise_types
    if current_user.administrator?
      ExerciseType.all
    else
      ExerciseType.where('owner_id = :owner_id OR owner_id is NULL', owner_id: current_user.id)
    end
  end

  def self.translate_all(exercise_types, translation_map)
    exercise_types.map {|exercise_type| translate(exercise_type, translation_map[exercise_type.id])}
  end

  def self.translate(exercise_type, translation)
    if translation
      exercise_type = exercise_type.dup
      exercise_type.name = translation.name
      exercise_type.description = translation.description
    end
    exercise_type
  end

  # returns a hash where the keys are exercise type IDs, and
  # values are exercise type translations.
  def self.get_translation_map(exercise_types, language_code)
    get_translations(exercise_types, language_code).index_by(&:exercise_type_id)
  end

  # returns
  def self.get_translations(exercise_types, language_code)
    ExerciseTypeTranslation
        .where(language_code: language_code)
        .joins(:exercise_type)
        .merge(exercise_types)
  end

  # returns an exercise type translation for the given exercise type.
  def self.get_translation(exercise_type, language_code)
    ExerciseTypeTranslation
        .where(language_code: language_code)
        .find_by_exercise_type_id(exercise_type.id)
  end
end
