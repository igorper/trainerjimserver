class UserExercisePhoto < ActiveRecord::Base
  has_attached_file :photo, styles: { large: "1400x900>", medium: "600x600>", thumb: "128x128>" }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  belongs_to :user
  belongs_to :exercise_type

  def thumb_photo_url
    photo.url(:thumb)
  end

  def medium_photo_url
    photo.url(:medium)
  end

  def large_photo_url
    photo.url(:large)
  end
end