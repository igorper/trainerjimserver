class MergeFirstLastName < ActiveRecord::Migration
  def change
    add_column :users, :full_name, :string
    Training.reset_column_information
    Training.all.each { |t|
      p.full_name = p.display_name
      p.save
    }
    remove_column :users, :first_name
    remove_column :users, :last_names
  end
end
