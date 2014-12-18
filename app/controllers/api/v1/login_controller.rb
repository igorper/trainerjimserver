class Api::V1::LoginController < ActionController::Base
  
  def login
    render :json => '{"ohMy":"Hello, world!"}'
  end

end
