class AddAttachmentPhotoToExerciseGroups < ActiveRecord::Migration
  def self.up
    change_table :exercise_groups do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :exercise_groups, :photo
  end
end
