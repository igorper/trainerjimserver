class Remodeling < ActiveRecord::Migration
  def change
    
    create_table :exercise_types do |t|
      t.string :name
    end
    
    add_column :exercises, :exercise_type_id, :integer
    remove_column :exercises, :name
    
    add_foreign_key :exercises, :exercise_types, :column => 'exercise_type_id', :dependent => :delete, :on_update => :cascade
    
    create_table :measurement_comments do |t|
      t.integer :timestamp
      t.string :comment
      t.integer :series_execution_id
    end
    
    add_foreign_key :measurement_comments, :series, :column => 'series_execution_id', :dependent => :delete, :on_update => :cascade

    add_column :measurements, :rating, :integer
    
    create_table :conversations do |t|
      t.integer :user1_id
      t.integer :user2_id
      t.string :text
      t.integer :datum  #TODO: popravi na datetime?+anglesko
      t.integer :measurement_id, :null => true
    end
    
    add_foreign_key :conversations, :measurements, :column => 'measurement_id', :dependent => :delete, :on_update => :cascade
    
  end
end
