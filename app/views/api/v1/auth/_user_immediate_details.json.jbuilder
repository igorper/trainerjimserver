json.(user, :id, :email, :full_name)

json.is_trainer user.trainer?

json.is_admin user.administrator?

json.photo user.photo.url(:medium)