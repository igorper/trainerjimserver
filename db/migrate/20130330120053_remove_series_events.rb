class RemoveSeriesEvents < ActiveRecord::Migration
  def change
    drop_table :series_events
  end
end
