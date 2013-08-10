# To change this template, choose Tools | Templates
# and open the template in the editor.

class UsersController < ApplicationController
  
  include AjaxHelper
  
  def list
    @users = User.find(:all)
    respond_to do |format|
      format.html
      format.json { render :json => @users.to_json(
          :only => [:id, :email, :full_name],
          :methods => [:display_name]
        )}
    end    
  end
  
  def list_trainees
    ajax_render User.find_all_by_trainer_id(current_user.id).to_json(
      :only => [:id, :email, :full_name],
      :methods => [:display_name]
    )
  end
  
  # @method POST, GET
  # @param email 
  # @param password
  # @returns `true` if the user was authenticated. Otherwise it returns `false`.
  def m_authenticate
    user = AuthenticationHelper.multi_auth(params)
    ajax_render user.is_a?(User)
  end
  
  # @method GET
  # @returns json the json of all trainees (their names and IDs)
  def trainees
    if user_signed_in? && current_user.trainer?
      # trainees = User.includes(:roles).where('roles.name IS NULL')
      @my_trainees = User.where(:trainer_id => current_user.id)
      respond_to do |format|
        format.html
        format.json { render :json => @my_trainees.to_json(
            :only => [:id, :email, :full_name],
            :methods => []
          )}
      end
    else
      render :nothing => true, :status => :forbidden
    end
  end
  
  
end
