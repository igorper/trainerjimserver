class AddUserIdToTrainings < ActiveRecord::Migration
  def change
    add_column :trainings, :trainee_user_id, :integer

    add_foreign_key :trainings, :users, :column => 'trainee_user_id', :dependent => :delete, :on_update => :cascade
    
    add_index :trainings, :trainee_user_id
  end
end
