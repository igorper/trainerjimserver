class Api::V1::MeasurementsController < ActionController::Base

  include AuthenticationHelper
  include TrainingHelper

  def index
    when_signed_in do
      @measurements = Measurement
                          .includes(:trainee, :training, trainee: [:trainer])
                          .where('trainers_users.id = :user_id OR measurements.trainee_id = :user_id', user_id: current_user.id)
                          .references(:trainee, trainee: [:trainer])
    end
  end

  def user_measurements
    when_trainer_of(params[:user_id]) { |trainee|
      @measurements = Measurement.includes(:training).where(trainee_id: trainee.id)
      render :index
    }
  end

  def detailed_measurements
    when_signed_in do
      @measurements = get_detailed_measurements
                          .where('trainers_users.id = :user_id', user_id: current_user.id)
                          .references(trainee: [:trainer])
      MeasurementHelper.translate_all!(@measurements, params[:language])
      render :detailed_list
    end
  end

  def detailed_user_measurements
    when_trainer_of(params[:user_id]) { |trainee|
      @measurements = get_detailed_measurements
                          .where('measurements.trainee_id = :trainee_id', trainer_id: current_user.id, trainee_id: trainee.id)
                          .references(:trainee, trainee: [:trainer])
      MeasurementHelper.translate_all!(@measurements, params[:language])
      render :detailed_list
    }
  end

  def show
    when_signed_in do
      @measurement = Measurement
                         .includes(:series_executions, {training: full_trainings_includes})
                         .find_by_id(params[:id])
      if @measurement.nil?
        render_not_found
      elsif !admin_or_trainer_of?(current_user, @measurement.trainee_id)
        render_forbidden
      else
        TrainingHelper.translate_exercise_types!(@measurement.training, params[:language])
      end
    end
  end

  def create
    when_trainer_of(params[:trainee_id]) { |_|
      measurement = to_measurement(params)
      measurement.save
      render partial: 'overview_measurement', locals: {measurement: measurement}
    }
  end

  private

  def to_measurement(params)
    measurement_params = params.permit(
        :trainee_id,
        :training_id,
        :start_time,
        :end_time,
        :rating,
        :comment
    )
    measurement_params[:series_executions] = to_series_executions(params[:series_executions])
    Measurement.new(measurement_params)
  end

  def to_series_executions(params)
    params.map { |series_execution_params|
      SeriesExecution.new(
          series_execution_params.permit(
              :num_repetitions,
              :weight,
              :rest_time,
              :duration_seconds,
              :rating,
              :series_id
          )
      )
    }
  end

  def get_detailed_measurements
    Measurement.includes(:series_executions, {trainee: [:trainer], training: full_trainings_includes})
  end


end