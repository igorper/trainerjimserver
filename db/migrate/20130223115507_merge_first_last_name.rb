class MergeFirstLastName < ActiveRecord::Migration
  def change
    add_column :users, :full_name, :string
    remove_column :users, :first_name
    remove_column :users, :last_names
  end
end
