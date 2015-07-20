class RemoveColumnsFromSeriesExecutions < ActiveRecord::Migration
  def change
    remove_column :series_executions, :start_timestamp
    remove_column :series_executions, :end_timestamp
  end
end
