class Api::V1::ExerciseTypesController < ActionController::Base

  def index
    @exercise_types = ExerciseType.all
  end

  def show
    @exercise_type = ExerciseType.find_by_guid(params[:id])
  end

  def create
    @exercise_type = ExerciseType.create(name: params[:name], image: params[:file])
  end

end