class AddHistoricalToTraining < ActiveRecord::Migration
  def change
    add_column :trainings, :historical, :boolean, default: false
  end
end
