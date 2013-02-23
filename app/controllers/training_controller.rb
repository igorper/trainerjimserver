class TrainingController < ApplicationController
  # Returns an entire training for the user.
  # @method POST, GET
  # @param email 
  # @param password
  # @param id
  # @returns JSON a JSON encoded string containing the first training (together
  # with its exercises and series).
  def m_get
    AuthenticationHelper.mapi_authenticate params do |user|
      if user then
        render :json => Training.find_by_id_and_user_id(params[:id], user.id, :include => [:exercises, {:exercises => :series}]).to_json(TrainingHelper.training_full_view)
      else
        render :json => nil
      end
    end
  end
  
  # Lists all trainings for the current user
  # @method POST, GET
  # @param email 
  # @param password
  # @returns JSON a JSON encoded list all trainings
  def m_list
    AuthenticationHelper.mapi_authenticate params do |user|
      if user then
        render :json => Training.find_all_by_user_id(user.id).to_json(TrainingHelper.training_view)
      else
        render :json => nil
      end
    end
  end
end
