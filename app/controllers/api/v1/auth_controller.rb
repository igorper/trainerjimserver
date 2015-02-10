class Api::V1::AuthController < ActionController::Base

  def login
    @user = User.find_by_email(params[:email])
    if @user && @user.valid_password?(params[:password])
      @user.remember_me!(extend_period=true) if params[:rememberMe]
      sign_in(:user, @user)
    else
      render status: :bad_request
    end
  end

  def signup
    User.create(email: params[:email], password: params[:password], full_name: params[:full_name], roles: [])
    render json: {}
  end

  def logout
    sign_out
    render json: {}
  end

  def is_logged_in
    render json: {is_logged_in: user_signed_in?}
  end

  def user_details
    if user_signed_in?
      @user = current_user
    else
      render status: :unauthorized
    end
  end

end
