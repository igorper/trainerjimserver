class ConvesrastionAddUsersToForeignKey < ActiveRecord::Migration
  def change
        rename_column :conversations, :user1, :user1_id
        rename_column :conversations, :user2, :user2_id

    
        add_foreign_key :conversations, :users, :column => 'user1_id', :dependent => :delete, :on_update => :cascade
        add_foreign_key :conversations, :users, :column => 'user2_id', :dependent => :delete, :on_update => :cascade

  end
end
