json.partial! 'api/v1/exercise_types/metadata', exercise_type: @exercise_type

json.(@exercise_type, :description)