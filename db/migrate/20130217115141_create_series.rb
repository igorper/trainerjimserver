class CreateSeries < ActiveRecord::Migration
  def change
    create_table :series do |t|
      t.integer :exercise_id, :null => false
      t.integer :order
      t.integer :repeat_count
      t.integer :weight
      t.integer :rest_time, :null => false, :default => 0

      t.timestamps
    end

    add_index :series, :exercise_id

    add_foreign_key :series, :exercises, :column => 'exercise_id', :on_delete => :cascade, :on_update => :cascade
  end
end
