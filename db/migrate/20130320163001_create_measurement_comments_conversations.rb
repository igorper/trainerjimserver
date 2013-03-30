class CreateMeasurementCommentsConversations < ActiveRecord::Migration
  def change
    ############################################################################
    ### MEASUREMENT COMMENTS (these comments are )
    ##
    create_table :measurement_comments do |t|
      t.integer :timestamp
      t.string :comment
      t.references :series_execution
    end
    
    add_foreign_key :measurement_comments, :series_executions, :column => :series_execution_id, :dependent => :delete, :on_update => :cascade
    add_index :measurement_comments, :series_execution_id

    ############################################################################
    ### CONVERSATIONS
    ##
    create_table :conversations do |t|
      t.integer :sender_id
      t.string :text
      t.datetime :date
      t.references :measurement, :null => false
    end
    
    add_foreign_key :conversations, :measurements, :column => :measurement_id, :dependent => :delete, :on_update => :cascade
    add_foreign_key :conversations, :users, :column => :sender_id, :dependent => :delete, :on_update => :cascade
    add_index :conversations, :measurement_id
    add_index :conversations, :sender_id
    
  end
end
