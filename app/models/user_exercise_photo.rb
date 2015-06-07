class UserExercisePhoto < ActiveRecord::Base
  has_attached_file :photo,
                    styles: { large: "1400x900>", medium: "600x600>", thumb: "128x128>" },
                    convert_options: { thumb: '-quality 90', medium: '-quality 85', large: '-quality 80' }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  belongs_to :user
  belongs_to :exercise_type
end