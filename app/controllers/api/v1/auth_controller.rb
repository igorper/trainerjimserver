class Api::V1::AuthController < ActionController::Base

  def login
    user_to_log_in = User.find_by_email(params[:email])
    if user_to_log_in && user_to_log_in.valid_password?(params[:password])
      user_to_log_in.remember_me!(extend_period=true) if params[:rememberMe]
      sign_in(:user, user_to_log_in)
      render json: {}
    else
      render json: {}, status: 404
    end
  end

  def signup
    User.create(email: params[:email], password: params[:password], full_name: params[:email], roles: [])
    render json: {}
  end

  def logout
    sign_out
    render json: {}
  end

  def is_logged_in
    render json: {is_logged_in: user_signed_in?}
  end

  def username
    if user_signed_in?
      render json: {username: current_user.email}
    else
      render json: {}, status: :unauthorized
    end
  end

end
