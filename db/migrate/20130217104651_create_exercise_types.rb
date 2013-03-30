class CreateExerciseTypes < ActiveRecord::Migration
  def change
    ############################################################################
    ### EXERCISE TYPES (contains a list of known exercise names)
    ##
    create_table :exercise_types do |t|
      t.string :name
      
      t.timestamps
    end
  end
end
