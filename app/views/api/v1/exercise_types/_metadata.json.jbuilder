json.(exercise_type, :id, :name, :short_name, :image_file_name)

json.image_url exercise_type.image.url

json.thumb_image_url exercise_type.image.url(:thumb)

json.medium_image_url exercise_type.image.url(:medium)

json.large_image_url exercise_type.image.url(:large)