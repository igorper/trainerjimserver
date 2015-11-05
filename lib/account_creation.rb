# Usage:
# bash> RAILS_ENV=staging rails c
# rails> load(Rails.application.root.join('lib/account_creation.rb'))
# rails> User.find_by_email('matej.urbas@hotmail.com').delete
# rails> AccountCreation.create_trainer("matej.urbas@hotmail.com", "test1234", "Matej Urbas")

module AccountCreation
  extend FactoryGirl::Syntax::Methods

  def self.create_trainer(email, password, full_name)
    trainer = create(:user, :trainer, email: email, full_name: full_name, password: password)
    training = create(:training, name: 'Full Body Training')

    add_exercise(
        training,
        'Bench Press Dumbbell',
        [
            {repeat_count: 8, weight: 8, rest_time: 30},
            {repeat_count: 10, weight: 8, rest_time: 30},
            {repeat_count: 12, weight: 8, rest_time: 30},
        ]
    )

    add_exercise(
        training,
        'Wide Grip Lat Pull Down',
        [
            {repeat_count: 8, weight: 30, rest_time: 30},
            {repeat_count: 10, weight: 30, rest_time: 30},
            {repeat_count: 12, weight: 30, rest_time: 30},
        ]
    )

    add_exercise(
        training,
        'Cuban Dumbbell Press',
        [
            {repeat_count: 8, weight: 8, rest_time: 30},
            {repeat_count: 10, weight: 8, rest_time: 30},
            {repeat_count: 12, weight: 8, rest_time: 30},
        ]
    )

    add_exercise(
        training,
        'Leg Press',
        [
            {repeat_count: 8, weight: 65, rest_time: 30},
            {repeat_count: 10, weight: 65, rest_time: 30},
            {repeat_count: 12, weight: 65, rest_time: 30},
        ]
    )

    add_exercise(
        training,
        'Lying Leg Curl Machine',
        [
            {repeat_count: 8, weight: 55, rest_time: 30},
            {repeat_count: 10, weight: 55, rest_time: 30},
            {repeat_count: 12, weight: 55, rest_time: 30},
        ]
    )

    add_exercise(
        training,
        'Triceps Pushdown with Rope and Cable',
        [
            {repeat_count: 8, weight: 20, rest_time: 30},
            {repeat_count: 10, weight: 20, rest_time: 30},
            {repeat_count: 12, weight: 20, rest_time: 30},
        ]
    )

    add_exercise(
        training,
        'Biceps Curl with Dumbbell',
        [
            {repeat_count: 8, weight: 6, rest_time: 30},
            {repeat_count: 10, weight: 6, rest_time: 30},
            {repeat_count: 12, weight: 6, rest_time: 30},
        ]
    )

    add_exercise(
        training,
        'Standing Calf Raises using Machine',
        [
            {repeat_count: 8, weight: 15, rest_time: 30},
            {repeat_count: 10, weight: 15, rest_time: 30},
            {repeat_count: 12, weight: 15, rest_time: 30},
        ]
    )

    add_exercise(
        training,
        'Crunches',
        [
            {repeat_count: 8, weight: 10, rest_time: 30},
            {repeat_count: 10, weight: 10, rest_time: 30},
            {repeat_count: 12, weight: 10, rest_time: 30},
        ]
    )

    trainer.trainings = [training]
    trainer.trainer = trainer
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