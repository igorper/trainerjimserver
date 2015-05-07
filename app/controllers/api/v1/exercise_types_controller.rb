class Api::V1::ExerciseTypesController < ActionController::Base

  def index
    if user_signed_in?
      if current_user.administrator?
        @exercise_types = ExerciseType.all
      else
        @exercise_types = ExerciseType.where("owner_id = :owner_id OR owner_id is NULL",
                                             owner_id: current_user.id)
      end
    else
      render status: :unauthorized
    end
  end

  def show
    @exercise_type = ExerciseType.find_by_id(params[:id])
  end

  def create
    if user_signed_in? && current_user.administrator?
      if params[:id]
        edit_exercise_type
        return
      end
      create_new_exercise_type
      return
    end
    render status: :unauthorized
  end

  def destroy
    if user_signed_in? && current_user.administrator?
      @exercise_type = ExerciseType.find_by_id(params[:id])
      @exercise_type.destroy
    else
      render status: :unauthorized
    end
  end

  private
  def create_new_exercise_type
    @exercise_type = ExerciseType.create(
        name: params[:name],
        short_name: params[:short_name],
        image: params[:file],
        owner_id: params[:owner_id]
    )
  end

  private
  def edit_exercise_type
    @exercise_type = ExerciseType.find_by_id(params[:id])
    @exercise_type.name = params[:name]
    @exercise_type.short_name = params[:short_name]
    @exercise_type.owner_id = params[:owner_id]
    if params[:file]
      @exercise_type.image = params[:file]
    end
    @exercise_type.save
  end


end