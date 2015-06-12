class RemoveAttachmentImageFromExerciseType < ActiveRecord::Migration
  def change
    remove_attachment :exercise_types, :image
  end
end
