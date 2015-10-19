module AccountCreation
  extend FactoryGirl::Syntax::Methods

  def self.create_trainer(email, password, full_name)
    trainer = create(:user, :trainer, email: email, full_name: full_name, password: password)
    training = create(:training, name: 'Maximum Power Training')

    add_exercise(training, 'Bench Press', (1..3).map { |_| {repeat_count: 10, weight: 25, rest_time: 60} })
    add_exercise(training, 'Incline Bench Press', (1..2).map { |_| {repeat_count: 8, weight: 50, rest_time: 30} })
    add_exercise(training, 'Row, Bent Over, Underhand Grip', (1..4).map { |_| {repeat_count: 12, weight: 5, rest_time: 30} }, guidance_type = 'duration')

    trainer.trainings = [training]
    trainer.save
  end

  def self.add_exercise(training, exercise_type_name, series, guidance_type = 'manual')
    training.exercises << build(:exercise) do |exercise|
      exercise.exercise_type = ExerciseType.find_by_name(exercise_type_name)
      exercise.guidance_type = guidance_type
      exercise.series = series.map do |series_datum|
        build(:series, series_datum)
      end
    end
  end
end