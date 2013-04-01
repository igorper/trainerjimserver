class AddCommentToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :comment, :string
  end
end
