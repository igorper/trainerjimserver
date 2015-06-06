class Api::V1::Trainees::TraineeTrainingsController < ActionController::Base

  include TrainingHelper
  include AuthenticationHelper

  def index
    when_trainer_of(params[:trainee_id]) { |trainee|
      @training_list = active_trainings(Training.where(trainee_id: trainee.id))
      render 'api/v1/trainings/index'
    }
  end

  def show
    when_trainer_of(params[:trainee_id]) { |trainee|
      @training = full_trainings.find_by(id: params[:id], trainee_id: trainee.id)
      render 'api/v1/trainings/show'
    }
  end

  def create
    when_trainer_of(params[:trainee_id]) { |trainee|
      if params[:isPreparedWorkout]
        add_prepared_workout(trainee.id, current_user.id, params[:preparedTrainingId])
      else
        save_training_and_render(trainee.id, params[:id])
      end
    }
  end

  def destroy
    when_trainer_of(params[:trainee_id]) { |trainee|
      archive_training_and_render(trainee.id, params[:id])
    }
  end
end