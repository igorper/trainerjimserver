module AuthenticationHelper
  # Tries to authenticate the user with the given email by checking the password.
  # On success it returns a User instance. On failure it returns `false`.
  # 
  # This method also marks the authentication
  #
  # @param session the current session of the user.
  # @param email string the email of the user trying to log in.
  # @param password string 
  #
  def self.login_with_password(session, email, password)
    user = AuthenticationHelper.auth_with_password(email, password)
    if user then
      AuthenticationHelper.do_login(session, user)
    end
    return user
  end
  
  def self.auth_with_password(email, password)
    user = User.find_by_email email
    if user and user.authenticate(password) then
      return user
    else
      return false
    end
  end
  
  def self.current_user_id(session)
    return session[:Authentication_user_id]
  end
  
  def self.current_user_display_name(session)
    return session[:Authentication_user_display_name]
  end
  
  def self.do_login(session, user)
    session[:Authentication_user_id] = user.id
    session[:Authentication_user_display_name] = user.display_name
  end
  
  def do_logout
    reset_session
  end
end
