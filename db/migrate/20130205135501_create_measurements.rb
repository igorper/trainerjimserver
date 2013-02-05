class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.belongs_to :user, :null => false
      t.binary :data

      t.timestamps
    end
    
    add_index :measurements, :user_id
  end
end
