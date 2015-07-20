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
      render :show
    end
  end

  def current
    when_signed_in do
      @user = current_user
      render :show
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
      render :show
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
      render :show
    end
  end

  def confirm
    @user = User.confirm_by_token(params[:token])
    render :show
  end

  def confirm_user_details
    confirmed_user = User.confirm_by_token(params[:token])
    # TODO: Devise sets the confirmation token. This invalidates the token that the user received in the e-mail. Instead
    # of saving the user `confirm_by_token` returns, we fetch a new user and set its password and full name only. This
    # avoids saving the modified confirmation token
    @user = User.find_by_id(confirmed_user.id)
    @user.full_name = params[:full_name]
    @user.password = params[:password]
    @user.save!
    render :show
  end

end