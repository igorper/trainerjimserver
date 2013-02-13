class AuthenticationController < ApplicationController
    
  def login
  end
  
  # POST
  # @param email 
  # @param password
  # DISABLED @param redirect_url (optional; if given, but empty, it redirects back to the
  # requesting page)
  def authenticate
    login_success = !!login_with_password(params[:email], params[:password])
    redirect_url = params[:redirect_url]
#    if redirect_url.nil? then
    render :json => login_success
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
      do_login(user)
      return user
    else
      return false
    end
  end
  
  # Actually logs the given user in. It puts the user's ID into the session
  # store
  def do_login(user)
    session[:user_id] = user.id
  end
  
  # Logs the user out (and drops all data from the session).
  def do_logout()
    reset_session
  end
end
