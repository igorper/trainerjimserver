class Api::V1::AuthController < ActionController::Base

  include AuthenticationHelper

  def login
    @user = User.find_by_email(params[:email])
    if @user && @user.valid_password?(params[:password])
      @user.remember_me!(extend_period=true) if params[:rememberMe]
      sign_in(:user, @user)
    else
      render_bad_request
    end
  end

  def signup
    registration_token = RegistrationToken.find_by(token: params[:registration_token])
    if registration_token
      registration_token.destroy
      @user = User.create(email: params[:email], password: params[:password], full_name: params[:full_name], roles: [])
    else
      render_bad_request
    end
  end

  def logout
    sign_out
    render nothing: true
  end

  def is_logged_in
  end

end
