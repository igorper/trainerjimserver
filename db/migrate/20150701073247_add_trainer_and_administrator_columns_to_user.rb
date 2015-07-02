class AddTrainerAndAdministratorColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_administrator, :boolean, default: false, null: false
    add_column :users, :is_trainer, :boolean, default: false, null: false
  end
end
