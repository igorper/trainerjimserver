class DashboardController < ApplicationController
  def show
    @trainees = User.find(:all)
  end
    
  def measurements
    selected = params[:user]
    @measurements = User.find_by_id(selected).measurements
    respond_to do |format|
      format.html {render :layout => false}
      format.json  { render :json => @measurements.to_json}    
    end
  end
  
  def exercisedates
    #Group by month first, then by date
    @measurements = Measurement
    .select("start_time, id,end_time").find_all_by_user_id(params[:user])
    .group_by{|m| m.start_time.strftime("%B") }
    .map{|k,v| {:month => k, :days => v.group_by{|m| m.start_time.day }
        .map{ |k,v| {:day => k, :measurements => v}}
        .sort_by{|k,v| v}
        .reverse}
    }
    respond_to do |format|
      format.json  { render :json => @measurements.to_json() }
    end
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
    @exerciseTypes = SeriesExecution.where("measurement_id=?",params[:id]).group_by{|k| k.exercise.exercise_type.name }
    .map{ |k,v| {:name => k, :executions => v}}
    respond_to do |format|
      format.html {render :layout => false}
      format.json { render:json => {:types => @exerciseTypes, :measurement => @measurement.as_json(:include => [:measurement_comment])}}
      #        format.json  { render :json => @measurement.to_json(
      #            :include => [:series_executions]        
      #          )}
    
    end
  
  
  end
  
  
end
