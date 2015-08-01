module ExerciseTypeHelper
  def current_user_exercise_types
    if current_user.administrator?
      ExerciseType.all
    else
      ExerciseType.where('owner_id = :owner_id OR owner_id is NULL', owner_id: current_user.id)
    end
  end
end
