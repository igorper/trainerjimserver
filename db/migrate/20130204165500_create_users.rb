class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, :primary_key => 'id' do |t|
      t.string :email
      t.string :password_digest
      t.integer :role
      t.timestamps
    end
    
    add_index :users, :email, :unique => true
  end
end
