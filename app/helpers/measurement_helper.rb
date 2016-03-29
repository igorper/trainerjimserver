module MeasurementHelper
  def self.translate_all!(measurements, language_code)
    if measurements
      measurements.each { |measurement|
        TrainingHelper.translate_exercise_types!(measurement.training, language_code)
      }
    end
  end
end
