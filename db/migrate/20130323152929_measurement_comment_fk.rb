class MeasurementCommentFk < ActiveRecord::Migration
  def change       
    remove_foreign_key :measurement_comments, :column => "series_execution_id"
  end
end
