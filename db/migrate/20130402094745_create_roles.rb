class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, :null => false

      t.timestamps
    end
    
    add_index :roles, :name, :unique => true
    
    # Add the admin and trainer roles:
    Role.new(:name => Role.administrator).save()
    Role.new(:name => Role.trainer).save()
  end
end
