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
end
