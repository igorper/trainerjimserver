class CreateMeasuementComments < ActiveRecord::Migration
  def change
        add_foreign_key :measurement_comments, :series_executions, :column => 'measurement_id', :dependent => :delete, :on_update => :cascade
  end
end
