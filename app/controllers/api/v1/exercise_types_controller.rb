class Api::V1::ExerciseTypesController < ActionController::Base

  include AuthenticationHelper

  EXERCISE_TYPES_PER_PAGE = 25

  def index
    when_signed_in do
      if current_user.administrator?
        @exercise_types = ExerciseType.all
      else
        @exercise_types = ExerciseType.where("owner_id = :owner_id OR owner_id is NULL",
                                             owner_id: current_user.id)
      end
      @exercise_types = @exercise_types.page(params[:page]).per(EXERCISE_TYPES_PER_PAGE)
      if params[:mode] == 'paginationInfo'
        render json: {total_items: @exercise_types.total_count, items_per_page: EXERCISE_TYPES_PER_PAGE}
        return
      end
    end
  end

  def show
    @exercise_type = ExerciseType.find_by_id(params[:id])
  end

  def create
    when_signed_in do
      if params[:id]
        edit_exercise_type
      else
        create_new_exercise_type
      end
    end
  end

  def destroy
    when_signed_in do
      if current_user.administrator?
        @exercise_types = ExerciseType.all
      else
        @exercise_types = ExerciseType.where(owner_id: current_user.id)
      end
      @exercise_type = @exercise_types.find_by(id: params[:id])
      @exercise_type.destroy
    end
  end

  private
  def edit_exercise_type
    if current_user.administrator?
      @exercise_type = ExerciseType.all
    else
      @exercise_type = ExerciseType.where(owner_id: current_user.id)
    end
    @exercise_type = @exercise_type.find_by_id(params[:id])
    if @exercise_type
      edit_exercise_type_impl(@exercise_type)
    end
  end

  private
  def edit_exercise_type_impl(exercise_type)
    exercise_type.name = params[:name]
    @exercise_type.short_name = params[:short_name]
    @exercise_type.owner_id = params.fetch(:owner_id, current_user.id)
    if params[:file]
      @exercise_type.image = params[:file]
    end
    @exercise_type.save
  end

  private
  def create_new_exercise_type
    @exercise_type = ExerciseType.create(
        name: params[:name],
        short_name: params[:short_name],
        image: params[:file],
        owner_id: params.fetch(:owner_id, current_user.id)
    )
  end


end