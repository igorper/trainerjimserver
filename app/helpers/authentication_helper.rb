module AuthenticationHelper
  def self.current_user_id(session)
    return session[:Authentication_user_id]
  end
  
  def self.current_user_display_name(session)
    return session[:Authentication_user_display_name]
  end
  
  def self.do_login(user, session)
    session[:Authentication_user_id] = user.id
    session[:Authentication_user_display_name] = user.display_name
  end
  
  def do_logout
    reset_session
  end
end
