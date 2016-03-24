module ExerciseTypeHelper
  def current_user_exercise_types
    if current_user.administrator?
      ExerciseType.all
    else
      ExerciseType.where('owner_id = :owner_id OR owner_id is NULL', owner_id: current_user.id)
    end
  end

  def self.translate_exercise_type(exercise_types, language_code)
    translations = ExerciseTypeTranslation
                       .where(language_code: language_code)
                       .joins(:exercise_type)
                       .merge(exercise_types)
                       .index_by(&:exercise_type_id)
    exercise_types.map do |exercise_type|
      translation = translations[exercise_type.id]
      if translation
        exercise_type.name = translation.name
        exercise_type.description = translation.description
      end
      exercise_type
    end
  end
end
