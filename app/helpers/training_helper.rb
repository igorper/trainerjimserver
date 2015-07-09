module TrainingHelper
  def self.to_new_training(params)
    filtered_params = params.permit(:name, :is_circular)
    filtered_params[:exercises] = params[:exercises].map.with_index do |exercise_params, i|
      exercise_params[:order] = i
      ExerciseHelper.to_new_exercise(exercise_params)
    end
    Training.new(filtered_params)
  end

  def save_training(edited_training, trainee_id, original_training = nil)
    if original_training
      edited_training.original_training = original_training
      original_training.historical = true
      original_training.save
    end
    edited_training.trainee_id = trainee_id
    edited_training.save
    edited_training
  end

  def save_training_and_render(trainee_id, training_id)
    edited_training = TrainingHelper.to_new_training(params)
    existing_training = Training.find_by(trainee_id: trainee_id, id: training_id)
    @saved_training = save_training(edited_training, trainee_id, existing_training)
    render 'api/v1/trainings/create'
  end

  def archive_training_and_render(trainee_id, training_id)
    @training = Training.find_by(trainee_id: trainee_id, id: training_id)
    if @training
      @training.historical = true
      @training.save
      render 'api/v1/trainings/destroy'
    else
      render status: :bad_request
    end
  end

  def add_prepared_workout(trainee_id, trainer_id, prepared_training_id)
    prepared_training = Training.find_by(trainee_id: trainer_id, id: prepared_training_id)
    if prepared_training
      @training = prepared_training.amoeba_dup
      @training.trainee_id = trainee_id
      @training.original_training = prepared_training
      @training.save
      render 'api/v1/trainings/show'
    else
      render status: :bad_request
    end
  end

  def full_trainings
    Training.includes(exercises: [:exercise_type, :series])
  end

  def active_trainings(trainings)
    trainings.where(historical: false)
  end

end
