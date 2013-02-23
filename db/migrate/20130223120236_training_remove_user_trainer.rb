class TrainingRemoveUserTrainer < ActiveRecord::Migration
  def change
    remove_column :trainings, :user_id
    remove_column :trainings, :trainer_id
  end
end
