module AuthenticationHelper
  
  ##############################################################################
  ## UTILITIES (instance)
  #
  def do_logout
    reset_session
  end
  
  def logged_in?
    return AuthenticationHelper.is_logged_in?(session)
  end
  
  ##############################################################################
  ## UTILITIES (global)
  #
  def self.current_user_id(session)
    return session[:Authentication_user_id]
  end
  
  def self.current_user_display_name(session)
    return session[:Authentication_user_display_name]
  end
  
  def self.is_logged_in?(session)
    return !session[:Authentication_user_id].nil?
  end
  
  ##############################################################################
  ## LOGIN
  #

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
  
  # @param params the request parameters (from GET or POST)
  # @param block this method is called with either a `User` instance (if the
  # authentication succeeded) or `null` if the authentication failed.
  def self.mapi_authenticate(params, &block)
    user = AuthenticationHelper.multi_auth(params)
    yield user.is_a?(Symbol) ? null : user
  end
  
  # @param params the request parameters (from GET or POST)
  # @returns a `User` instance in case the authentication worked, `null` if the
  #          authentication tokens are invalid (e.g., wrong password), or a
  #          symbol, which describes the code of the error.
  def self.multi_auth(params)
    # Check if the password and email are present:
    if params[:email].present? && params[:password].present? then
      return AuthenticationHelper.auth_with_password(params[:email], params[:password])
    else
      return :auth_method_unknown
    end
  end
  
  def self.auth_with_password(email, password)
    user = User.find_by_email email
    if user and user.authenticate(password) then
      return user
    else
      return false
    end
  end
  
  def self.do_login(session, user)
    session[:Authentication_user_id] = user.id
    session[:Authentication_user_display_name] = user.display_name
  end
  
  ##############################################################################
  ## REGISTRATION
  #
  
  # @returns if failure, returns either the result of `is_password_valid`,
  # :user_exists, :email_invalid
  def self.register_with_password(email, password, retyped_password, full_name)
    # Check that the password is okay:
    pwd_check_result = AuthenticationHelper.is_password_valid(password, retyped_password)
    if pwd_check_result != true then
      return pwd_check_result
    end
    
    # Check the email address:
    begin
      Mail::Address.new(email)
    rescue
      return :email_invalid
    end
    
    # Check if the user exists:
    existing_user = User.find_by_email email
    if existing_user then
      return :user_exist
    else
      user = User.create!(:email => email, :password => password, :admin => false, :full_name => full_name)
      return user
    end
  end
  
  # @returns one of: :retyped_password_mismatch, :password_short, :okay
  def self.is_password_valid(password, retyped_password)
    if password.blank? || password.length < 8 then
      return :password_short
    end
    
    if password != retyped_password then
      return :retyped_password_mismatch
    end
    
    return true
  end
end
