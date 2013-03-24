class AddDurationToSeriesExecution < ActiveRecord::Migration
  def change
    add_column :series_executions, :duration_seconds, :integer, :default => 0
  end
end
