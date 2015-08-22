json.array! @rest_times do |rest_times|
  json.user_id rest_times.id
  json.(rest_times, :rest_time)
end