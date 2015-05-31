json.(trainee, :id, :email, :full_name)

json.photo trainee.photo.url(:medium)