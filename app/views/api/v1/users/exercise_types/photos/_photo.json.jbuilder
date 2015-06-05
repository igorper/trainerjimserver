json.(exercise_photo, :user_id)

json.thumb_image_url exercise_photo.photo.url(:thumb)

json.medium_image_url exercise_photo.photo.url(:medium)

json.large_image_url exercise_photo.photo.url(:large)