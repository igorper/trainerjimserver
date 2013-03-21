class DashboardController < ApplicationController
  def show
    @trainees = User.find(:all)
  end
  
  def statistics
    selected = params[:user]
    @selected = User.find_by_id(selected)
    render :layout => false
  end
  
  def measurements
    selected = params[:user]
    @measurements = User.find_by_id(selected).measurements
    render :layout => false
    
  end
  
end
