module TrainingHelper

  def self.to_training(params)
    filtered_params = params.permit(*[:id, :name, exercises: ExerciseHelper.create_params])
    filtered_params[:exercises] = filtered_params[:exercises].map { |exercise_params| ExerciseHelper.to_exercise(exercise_params) }
    Training.new(filtered_params)
  end

end
