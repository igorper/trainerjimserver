class AuthenticationController < ApplicationController
    
  def login
  end
  
  # Useful for Ajax calls. This method starts a logged-in user session.
  # @method POST
  # @param email 
  # @param password
  # @returns JSON `true` on success, `false` otherwise.
  def authenticate
    render :json => !!login_with_password(params[:email], params[:password])
    #    redirect_url = params[:redirect_url]
    #    if redirect_url.nil? then
    #    elsif redirect_url.blank?
    #      redirect_to :back
    #    else
    #      redirect_to redirect_url
    #    end
  end
  
  ##############################################################################
  ## UTILITY METHODS
  #
  
  # Tries to authenticate the user with the given email by checkin the password.
  # On success it returns a User instance. On failure it returns `false`.
  # 
  # This method also marks the authentication
  #
  # @param email string the email of the user trying to log in.
  #
  def login_with_password(email, password)
    user = User.find_by_email email
    if user and user.authenticate(password) then
      AuthenticationHelper.do_login(user, session)
      return user
    else
      return false
    end
  end
end
