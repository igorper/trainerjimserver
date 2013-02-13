class AuthenticationController < ApplicationController
  def login
  end
  
  def authenticate
    head :ok
  end
end
