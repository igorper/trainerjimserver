class AddRatingAndTypeToSeriesExecution < ActiveRecord::Migration
  def change
    add_column :series_executions, :rating, :integer
    add_column :series_executions, :guidance_type, :string
  end
end
