class Api::V1::LoginController < ActionController::Base

  def login
    user_to_log_in = User.find_by_email(params[:email])
    if user_to_log_in && user_to_log_in.valid_password?(params[:password])
      sign_in(:user, user_to_log_in)
      render :json => '{}'
    else
      render :json => '{}', :status => 404
    end
  end

end
