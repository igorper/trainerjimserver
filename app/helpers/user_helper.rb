module UserHelper
  def new_trainee
    activate_new_user(params[:email], params[:full_name], params[:file], current_user, false)
  end

  def activate_new_user(email, full_name, photo_file, trainer, is_trainer)
    new_user = User.create(
        email: email,
        password: Devise.friendly_token.first(8),
        full_name: full_name,
        photo: photo_file,
        trainer: trainer,
        is_trainer: is_trainer
    )
    UserMailer.user_created(new_user, current_user).deliver_later
    new_user
  end
end
