class MeasurementCommentFkFix < ActiveRecord::Migration
  def change    
    rename_column :measurement_comments, :series_execution_id, :measurement_id 
  end
end
