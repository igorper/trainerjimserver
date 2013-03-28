module AuthenticationHelper
  
  ##############################################################################
  ## MAPI AUTHENTICATION
  #
  
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
    if user and user.valid_password?(password) then
      return user
    else
      return false
    end
  end
end
