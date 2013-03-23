class ConversationFixedDate < ActiveRecord::Migration
  def change
    remove_column :conversations, :datum
    add_column :conversations, :date, :datetime
    
  end
end
