class ConversationsController < ApplicationController
  
  def list
    @conversations = Conversation.where("user1_id=?",params[:user]).order(:date).limit(5)
    respond_to do |format|
        format.json { render:json => @conversations}
      end
  end  
end