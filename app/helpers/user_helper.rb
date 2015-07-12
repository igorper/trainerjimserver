module UserHelper
  def new_trainee
    activate_new_user(params[:email], params[:full_name], params[:file], current_user, false)
  end

  def new_trainer
    activate_new_user(params[:email], params[:full_name], params[:file], nil, true)
  end

  def activate_new_user(email, full_name, photo_file, trainer, is_trainer)
    generated_password = Devise.friendly_token.first(8)
    new_user = User.new(
        email: email,
        password: generated_password,
        full_name: full_name,
        photo: photo_file,
        trainer: trainer,
        is_trainer: is_trainer
    )
    new_user.skip_confirmation!
    new_user.save!
    UserMailer.activated_account(new_user, generated_password, current_user).deliver_later
    new_user
  end
end
