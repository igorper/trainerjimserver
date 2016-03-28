class Api::V1::ExerciseTypesController < ActionController::Base

  include AuthenticationHelper
  include ExerciseTypeHelper
  include ConditionalRenderHelper

  def index
    when_signed_in do
      last_modified = current_user_exercise_types.maximum(:updated_at).try(:utc)
      translations_map = ExerciseTypeHelper.get_translation_map(current_user_exercise_types, params[:language])
      last_modified_translation = translations_map.map { |_, et| et.updated_at }.max.try(:utc)
      if last_modified_translation && last_modified_translation > last_modified
        last_modified = last_modified_translation
      end
      if stale?(etag: "#{current_user.id}:#{params[:language]}:#{last_modified}", last_modified: last_modified)
        @exercise_types = current_user_exercise_types.includes(:exercise_groups)
        @exercise_types = ExerciseTypeHelper.translate_all(@exercise_types, translations_map)
      end
    end
  end

  def show
    @exercise_type = ExerciseType.find_by_id(params[:id])
    if !@exercise_type
      render_not_found
    else
      translation = ExerciseTypeHelper.get_translation(@exercise_type, params[:language])
      @exercise_type = ExerciseTypeHelper.translate(@exercise_type, translation)
    end
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
    @exercise_type.exercise_groups = get_exercise_groups(params[:exercise_groups])
    @exercise_type.save
  end

  def get_exercise_groups(exercise_group_ids)
    if exercise_group_ids
      exercise_group_ids.map do |exercise_group_id|
        ExerciseGroup.find_by_id(exercise_group_id)
      end
    else
      []
    end
  end

  private
  def create_new_exercise_type
    @exercise_type = ExerciseType.create(
        name: params[:name],
        short_name: params[:short_name],
        owner_id: params.fetch(:owner_id, current_user.id),
        exercise_groups: get_exercise_groups(params[:exercise_groups])
    )
  end


end