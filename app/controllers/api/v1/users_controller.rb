class Api::V1::UsersController < ActionController::Base

  include AuthenticationHelper

  def index
    when_admin do
      @users = User.all
    end
  end

end