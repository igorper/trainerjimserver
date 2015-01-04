module ExerciseHelper

  def self.to_exercise(params)
    filtered_params = params.permit(*create_params)
    Exercise.new(filtered_params)
  end

  def self.create_params
    [:id, :order]
  end

end
