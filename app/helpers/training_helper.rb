module TrainingHelper

  def self.to_training(params)
    filtered_params = params.permit(:id, :name)
    filtered_params[:exercises] = params[:exercises].map.with_index do |exercise_params, i|
      exercise_params[:order] = i
      ExerciseHelper.to_exercise(exercise_params)
    end
    Training.new(filtered_params)
  end

  # Saves the given training (in JSON form) as the user's new training.
  # This method also assigns the original training to the new training, if the
  # original is given.
  #
  # @return the newly saved training
  def save_new_training(edited_training, original_training = nil)
    if original_training
      edited_training.original_training = original_training
    end
    edited_training.trainee_id = current_user.id
    edited_training.save
    edited_training
  end

end
