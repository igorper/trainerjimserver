json.partial! 'api/v1/trainings/full_training', training: @measurement.training

json.(measurement, :id, :start_time, :end_time, :rating)

json.series_executions measurement.series_executions, partial: 'api/v1/series_executions/full_series_execution', as: :series_execution