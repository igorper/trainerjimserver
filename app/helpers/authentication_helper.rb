module AuthenticationHelper

  def when_signed_in
    if user_signed_in?
      yield
    else
      render json: {}, status: :unauthorized
    end
  end

  def when_admin
    if user_signed_in? && current_user.administrator?
      yield
    else
      render json: {}, status: :unauthorized
    end
  end

  def when_trainer_of(trainee_id)
    trainee_id = trainee_id.to_i
    if user_signed_in?
      if trainee_id == current_user.id
        yield current_user
      else
        trainee = User.find_by_id(trainee_id)
        if !trainee.nil? && trainer_of?(trainee)
          yield trainee
        else
          render json: {}, status: :unauthorized
        end
      end
    else
      render json: {}, status: :unauthorized
    end
  end

  def same_user?(user)
    user.id == current_user.id
  end

  def trainer_of?(trainee)
    !trainee.trainer.nil? && same_user?(trainee.trainer)
  end

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
