class AuthenticationController < ApplicationController
    
  def login
  end
  
  # Useful for Ajax calls. This method starts a logged-in user session.
  # @method POST
  # @param email 
  # @param password
  # @returns JSON `true` on success, `false` otherwise.
  def authenticate
    user = AuthenticationHelper.login_with_password(session, params[:email], params[:password])
    render :json => !!AuthenticationHelper.login_with_password(session, params[:email], params[:password])
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
end
