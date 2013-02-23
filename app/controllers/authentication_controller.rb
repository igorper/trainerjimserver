class AuthenticationController < ApplicationController
  
  include AjaxHelper
    
  def login
  end
  
  # Useful for Ajax calls. This method starts a logged-in user session.
  # @method POST
  # 
  # @param email 
  # @param password
  # @returns JSON `true` on success, `false` otherwise.
  def authenticate
    render :json => !!AuthenticationHelper.login_with_password(session, params[:email], params[:password])
  end
  
  def register
  end
  
  # Useful for Ajax calls. This method registers a new user but does not log in
  # the user. The user still has to log in.
  # 
  # @method POST
  # @param full_name 
  # @param email 
  # @param password
  # @param password_retyped
  # @returns JSON `true` on success, `false` otherwise.
  def create_user
    ajax_render AuthenticationHelper.register_with_password(params[:email], params[:password], params[:retyped_password], params[:full_name]), 'authentication'
  end
  
  ##############################################################################
  ## UTILITY METHODS
  #
end
