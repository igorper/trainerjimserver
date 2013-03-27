class ChangeMeasurementCommentFkToSeriesExecution < ActiveRecord::Migration
  def change
    remove_column :measurement_comments, :measurement_id
    add_column :measurement_comments, :series_executions_id, :integer
    
  end
end
