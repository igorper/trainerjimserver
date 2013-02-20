class TrainingController < ApplicationController
  # @method POST, GET
  # @param email 
  # @param password
  # @returns JSON a JSON encoded string containing the first training (together
  # with its exercises and series).
  def get
    user = AuthenticationHelper.auth_with_password(params[:email], params[:password])
    if user then
      render :json => Training.find_by_user_id(user.id, :include => [:exercises, {:exercises => :series}]).to_json(:include => {
          :exercises => { :include => {:series => {:only => [:id,:repeat_count, :weight]}}, :only => [:id, :name] }
        }, :only => [:id,:name])
    else
      render :json => nil
    end
  end
end
