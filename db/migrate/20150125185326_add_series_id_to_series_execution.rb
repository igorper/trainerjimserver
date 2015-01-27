class AddSeriesIdToSeriesExecution < ActiveRecord::Migration
  def change
    add_column :series_executions, :series_id, :integer, :null => false
    remove_column :series_executions, :exercise_type_id, :integer
    remove_column :series_executions, :guidance_type, :string

    add_foreign_key :series_executions, :series, :column => :series_id, :on_delete => :cascade, :on_update => :cascade

    add_index :series_executions, :series_id
  end
end
