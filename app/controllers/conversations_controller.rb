class ConversationsController < ApplicationController
  
  def list
    @conversations = Conversation.find_all_by_sender_id(params[:user], :order => :date, :limit => 5)
    respond_to do |format|
        format.json { render:json => @conversations}
      end
  end  
end