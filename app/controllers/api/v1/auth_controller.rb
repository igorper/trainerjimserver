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
    registration_token = RegistrationToken.find_by(token: params[:registration_token])
    if registration_token
      registration_token.destroy
      @user = User.create(email: params[:email], password: params[:password], full_name: params[:full_name], roles: [])
    else
      render json: {message: 'Invalid registration token.'}, status: :bad_request
    end
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
      render json: {}, status: :unauthorized
    end
  end

  def set_name
    if user_signed_in?
      @user = User.find_by_id(current_user.id)
      @user.full_name = params[:full_name]
      @user.save
    else
      render json: {}, status: :bad_request
    end
  end

  def set_password
    if user_signed_in? && current_user.valid_password?(params[:current_password])
      @user = User.find_by_id(current_user.id)
      @user.password = params[:new_password]
      @user.save
      sign_in(:user, User.find_by_id(current_user.id))
    else
      render json: {}, status: :bad_request
    end
  end

end
