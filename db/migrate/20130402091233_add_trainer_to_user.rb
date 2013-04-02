class AddTrainerToUser < ActiveRecord::Migration
  def change
    add_column :users, :trainer_id, :integer
    add_foreign_key :users, :users, :column => :trainer_id, :dependent => :nullify, :on_update => :cascade
    add_index :users, :trainer_id
  end
end
