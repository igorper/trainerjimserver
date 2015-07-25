json.(exercise_type, :id, :owner_id, :name, :short_name)

json.exercise_groups do
  json.array! exercise_type.exercise_groups.map { |exercise_group| exercise_group.id }
end