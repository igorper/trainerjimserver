class AddTrainerIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :trainer_id, :integer, :null => true
    add_foreign_key :users, :users, :column => 'trainer_id', :dependent => :delete, :on_update => :cascade

  end
end
