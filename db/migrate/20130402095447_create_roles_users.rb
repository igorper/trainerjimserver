class CreateRolesUsers < ActiveRecord::Migration
  def change
    create_table :roles_users do |t|
      t.references :user
      t.references :role
      
      t.foreign_key :users, :column => :user_id, :dependent => :delete, :on_update => :cascade
      t.foreign_key :roles, :column => :role_id, :dependent => :delete, :on_update => :cascade
    end
    
    add_index :roles_users, :user_id
    add_index :roles_users, :role_id
  end
end
