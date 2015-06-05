json.(photo, :id, :user_id, :exercise_type_id)

json.thumb_image_url photo.photo.url(:thumb)

json.medium_image_url photo.photo.url(:medium)

json.large_image_url photo.photo.url(:large)