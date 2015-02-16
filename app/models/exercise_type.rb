class ExerciseType < ActiveRecord::Base
  has_attached_file :image, styles: { large: "1400x900>", medium: "600x600>", thumb: "128x128>" }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates_attachment_file_name :image, matches: [/png\Z/, /jpe?g\Z/]
end