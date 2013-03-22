class DashboardController < ApplicationController
  def show
    @trainees = User.find(:all)
  end
  
  def statistics
    selected = params[:user]
    @selected = User.find_by_id(selected)
    @conversation = "Nekaj me je v krizu vsekalo"    
    
    #This line doesnt work when trying to display it in view. It works if u request text directly though.
    @conversation = Conversation.where(:user1_id => params[:user]).last
    
    render :layout => false
  end
  
  def measurements
    selected = params[:user]
    @measurements = User.find_by_id(selected).measurements
    render :layout => false
    
  end
  
  def exercise
     respond_to do |format|
       format.html
      format.json{ 
        render :json => SeriesExecution.where("exercise_id=? and measurement_id=?",params[:exercise],params[:measurement]).to_json
      }       
     end
  end
  
  def measurement
    @measurement = Measurement.find_by_id(params[:id])
      respond_to do |format|
      format.html {render :layout => false}
      format.json  { render :json => @measurement.to_json(
          :include => [:series_executions]        
        )}
    
  end
  
  
  end
  
  
end
