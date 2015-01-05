module ExerciseHelper

  def self.to_exercise(params)
    filtered_params = params.permit(:id, :order)
    filtered_params[:exercise_type_id] = params[:exercise_type][:id]
    filtered_params[:series] = params[:series].map.with_index do |series_params, i|
      series_params[:order] = i
      SeriesHelper.to_series(series_params)
    end
    Exercise.new(filtered_params)
  end

end
