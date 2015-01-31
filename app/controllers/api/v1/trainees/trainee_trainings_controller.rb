class Api::V1::Trainees::TraineeTrainingsController < ActionController::Base

  include TrainingHelper

  def index
    as_trainer_of { |trainee_id|
      @training_list = active_trainings(Training.where(trainee_id: trainee_id))
      render 'api/v1/trainings/index'
    }
  end

  def show
    as_trainer_of { |trainee_id|
      @training = full_trainings.find_by(id: params[:id], trainee_id: trainee_id)
      render 'api/v1/trainings/show'
    }
  end

  def create
    as_trainer_of { |trainee_id|
      if params[:isPreparedWorkout]
        add_prepared_workout(trainee_id, current_user.id, params[:preparedTrainingId])
      else
        save_training_and_render(trainee_id, params[:id])
      end
    }
  end

  def destroy
    as_trainer_of { |trainee_id|
      archive_training_and_render(trainee_id, params[:id])
    }
  end

  def as_trainer_of
    trainee_id = params[:trainee_id]
    if user_signed_in? and current_user.trainees.exists?(id: trainee_id)
      yield trainee_id
    else
      render status: :unauthorized
    end
  end

end