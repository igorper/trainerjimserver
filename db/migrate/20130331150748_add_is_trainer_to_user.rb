class AddIsTrainerToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_trainer, :boolean, :null => false, :default => false
  end
end
