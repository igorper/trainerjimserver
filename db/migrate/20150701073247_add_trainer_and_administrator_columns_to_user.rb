class AddTrainerAndAdministratorColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_administrator, :boolean, default: false
    add_column :users, :is_trainer, :boolean, default: false
  end
end
