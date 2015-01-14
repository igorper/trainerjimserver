json.(measurement, :id)
json.(measurement.training, :name)

json.series_executions measurement.series_executions, partial: 'api/v1/series_executions/full_series_execution', as: :series_execution