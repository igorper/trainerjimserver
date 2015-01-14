json.(series_execution, :id, :exercise_type_id, :num_repetitions, :weight, :rest_time, :duration_seconds)
json.exercise_type series_execution.exercise_type, :id, :name