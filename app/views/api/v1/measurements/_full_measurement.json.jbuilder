json.(measurement, :id, :trainee_id, :start_time, :end_time, :rating, :comment)

json.training do
  json.partial! 'api/v1/trainings/full_training', training: measurement.training
end

json.series_executions measurement.series_executions, partial: 'api/v1/series_executions/full_series_execution', as: :series_execution