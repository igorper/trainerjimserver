# Usage:
# > load(Rails.application.root.join('lib/export_exercise_types.rb'))
# > ExportExerciseTypes.to_csv_for_translation('d:/exercise_type_translations.csv')
require 'csv'

class ExportExerciseTypes
  def self.to_csv_for_translation(file_path)
    CSV.open(file_path, "w") do |csv|
      csv << [:id, :name, :description, :name_translation, :description_translation]
      ExerciseType.all.each {|exercise_type|
          csv << [exercise_type.id, exercise_type.name, exercise_type.description]
      }
    end
  end
end