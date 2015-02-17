class Api::V1::ExerciseTypesController < ActionController::Base

  def index
    @exercise_types = ExerciseType.all
  end

  def show
    @exercise_type = ExerciseType.find_by_id(params[:id])
  end

  def create
    if params[:id]
      @exercise_type = ExerciseType.find_by_id(params[:id])
      @exercise_type.name = params[:name]
      if params[:file]
        puts("Dat file!")
        @exercise_type.image = params[:file]
      end
      @exercise_type.save
    else
      @exercise_type = ExerciseType.create(name: params[:name], image: params[:file])
    end
  end


  def destroy
    if user_signed_in? && current_user.administrator?
      @exercise_type = ExerciseType.find_by_id(params[:id])
      @exercise_type.destroy
    else
      render status: :unauthorized
    end
  end

end