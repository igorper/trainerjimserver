class CreateSeriesEvents < ActiveRecord::Migration
  def change
    create_table :series_events do |t|
      t.integer :measurement_id
      t.integer :event_type
      t.timestamp :timestamp

      t.timestamps
    end

    add_foreign_key :series_events, :measurements, :column => 'measurement_id', :dependent => :delete, :on_update => :cascade
    add_index :series_events, :measurement_id
  end
end
