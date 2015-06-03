json.(training, :id, :name, :updated_at)

json.exercises training.exercises, partial: 'api/v1/exercises/full_exercise', as: :exercise

json.trainee do
  json.partial! 'api/v1/trainees/metadata', trainee: training.trainee
end
