class AddAttachmentImageToExerciseTypes < ActiveRecord::Migration
  def self.up
    change_table :exercise_types do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :exercise_types, :image
  end
end
