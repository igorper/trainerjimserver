class DashboardController < ApplicationController
  def show
    @trainees = User.find(:all)
    @selected = false
    if params[:selected]
    @selected = User.find_by_id(params[:selected])    
    end
  end
  
end
