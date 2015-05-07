class Api::V1::UsersController < ActionController::Base

  def index
    if user_signed_in? && current_user.administrator?
      @users = User.all
    else
      render status: :unauthorized
    end
  end

end