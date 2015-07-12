class Api::V1::UsersController < ActionController::Base

  include AuthenticationHelper
  include UserHelper

  def index
    when_admin do
      @users = User.all
    end
  end

  def create
    when_admin do
      @user = activate_new_user(params[:email], params[:full_name], params[:file], nil, params[:is_trainer])
    end
  end

  def current
    when_signed_in do
      render partial: 'user_immediate_details', locals: {user: current_user}
    end
  end

  def name
    when_signed_in do
      user_id = params[:id].to_i
      if current_user.id == user_id
        @user = current_user
      elsif current_user.administrator?
        @user = User.find_by_id(user_id)
      else
        render_unauthorized
        return
      end
      @user.full_name = params[:full_name]
      @user.save
    end
  end

  def password
    when_signed_in do
      user_id = params[:id].to_i
      if current_user.id == user_id && current_user.valid_password?(params[:current_password])
        @user = current_user
      elsif current_user.administrator?
        @user = User.find_by_id(user_id)
      else
        render_unauthorized
        return
      end
      @user.password = params[:new_password]
      @user.save
      sign_in(:user, User.find_by_id(current_user.id))
    end
  end

end