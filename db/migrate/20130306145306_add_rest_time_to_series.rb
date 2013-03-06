class AddRestTimeToSeries < ActiveRecord::Migration
  def change
    add_column :series, :rest_time, :integer
  end
end
