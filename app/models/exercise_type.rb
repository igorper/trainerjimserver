class ExerciseType < ActiveRecord::Base
  has_attached_file :image, styles: { large: "1400x900>", medium: "600x600>", thumb: "128x128>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  has_many :user_exercise_photos
  has_many :exercises
end