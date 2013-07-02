class Measurements::CommentsController < ApplicationController
  
  #Creates new measuremnt comment.
  # @Method POST
  # @param text
  # @param measurementId
  def new
    text = params[:text]
    series = params[:seriesExecutionId]
    timestamp = params[:timestamp]
    
    comment = MeasurementComment.create(
      :timestamp => timestamp,
      :comment =>text,
      :series_execution => SeriesExecution.find_by_id(series)) 
    respond_to do |format|
      if comment.save 
        format.json { render :json => {:comment => comment, :status=>"Post created."}, :status => 201 }
      else
        format.json { render :json => {:comment => comment.errors, :status=>"Error"}, :status => 400}
      end
    end
    
  end
  
  def delete
    id = params[:id]
    
    MeasurementComment.delete(id)
    
    respond_to do |format|
      format.json { render :json => {}}
    end
    
  end
  
end