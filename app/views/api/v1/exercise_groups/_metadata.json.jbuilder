json.(exercise_group, :id, :name, :is_machine_group)

json.thumb_image_url exercise_group.photo.url(:thumb)