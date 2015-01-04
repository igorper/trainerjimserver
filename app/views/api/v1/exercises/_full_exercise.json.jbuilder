json.(exercise, :id, :order, :machine_setting, :duration_after_repetition, :duration_up_repetition, :duration_middle_repetition, :duration_down_repetition, :guidance_type)
json.series exercise.series, :id, :repeat_count, :weight, :rest_time
json.exercise_type exercise.exercise_type, :id, :name