class ConversationsController < ApplicationController
  
  include AjaxHelper
  
  ### Returns last 5 conversations for given measurement
  ### @measurement - MeasurementId
  def list_by_measurement
    @conversations = Conversation.find_all_by_measurement_id(params[:measurement], :order => "date desc", :limit => 5)
    respond_to do |format|
      format.json { render:json => @conversations}
    end
  end

  ### Creates a new conversation comment.
  ### @text
  ### @measurementID
  ### User needs to be logged in
  def new
    conversation = Conversation.new( :text => params[:text],
      :measurement => Measurement.find_by_id(params[:measurement_id]),
      :date => DateTime.now,
      :sender =>  current_user)   
    conversation.save
    respond_to do |format|
      format.json {render:json => current_user}      
    end
  end
  
end