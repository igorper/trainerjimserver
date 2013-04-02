class RemoveRoleAndIsTrainerFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :role
    remove_column :users, :is_trainer
  end

  def down
    add_column :users, :is_trainer, :boolean
    add_column :users, :role, :integer
  end
end
