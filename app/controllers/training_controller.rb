class TrainingController < ApplicationController
  
  include AjaxHelper
  include AuthenticationHelper
  
  def show
    @t = Training.find_by_id(params[:id])
  end
  
  # Returns an entire training for the user.
  # @method POST, GET
  # @param email 
  # @param password
  # @param id
  # @returns JSON a JSON encoded string containing the first training (together
  # with its exercises and series).
  def m_get
    with_auth_mapi do |user|
      ajax_render Training.find_by_id(params[:id], :include => [:exercises, {:exercises => :series}]).to_json(TrainingHelper.training_full_view)
    end
  end
  
  # Lists all trainings for the current user
  # @method POST, GET
  # @param email 
  # @param password
  # @returns JSON a JSON encoded list all trainings
  def m_list
    with_auth_mapi do |user|
      ajax_render Training.all.to_json(TrainingHelper.training_view)
    end
  end
end
