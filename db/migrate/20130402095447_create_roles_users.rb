class CreateRolesUsers < ActiveRecord::Migration
  def change
    create_table :roles_users do |t|
      t.references :user
      t.references :role
    end

    add_index :roles_users, :user_id
    add_index :roles_users, :role_id

    add_foreign_key :roles_users, :users, :column => :user_id, :on_delete => :cascade, :on_update => :cascade
    add_foreign_key :roles_users, :roles, :column => :role_id, :on_delete => :cascade, :on_update => :cascade
  end
end
