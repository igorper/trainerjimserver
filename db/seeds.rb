# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

def is_none(ex)
  ex.nil? || ex.downcase == 'none'
end

exercise_types_data = CSV.read(Rails.root.join('data', 'exercise_types.csv'))
body_groups = exercise_types_data.map { |row| row[1] }.uniq.reject(&method(:is_none)).map { |group| ExerciseGroup.create(name: group) }
machine_groups = exercise_types_data.map { |row| row[2] }.uniq.reject(&method(:is_none)).map { |group| ExerciseGroup.create(name: group, is_machine_group: true) }
exercise_groups = (body_groups + machine_groups).map{|grp| [grp.name, grp]}.to_h
exercise_types = exercise_types_data.map { |row| ExerciseType.create(name: row[0], exercise_groups: [row[1], row[2]].map {|exercise_group| exercise_groups[exercise_group] }.compact) }


trainer = User.create(email: 'jim@example.com', password: 'trainerjim', full_name: 'Jim the Trainer', is_trainer: true)
matej = User.create(email: 'matej.urbas@gmail.com', password: 'trainerjim', full_name: 'Matej', is_administrator: true, trainer: trainer)
igor = User.create(email: 'igor.pernek@gmail.com', password: 'trainerjim', full_name: 'Igor', is_administrator: true, trainer: trainer)
damjan = User.create(email: 'damjan.obal@example.com', password: 'trainerjim', full_name: 'Damjan', is_administrator: true, trainer: trainer)
blaz = User.create(email: 'snuderl@example.com', password: 'trainerjim', full_name: 'Blaz', is_administrator: true, trainer: trainer)
marusa = User.create(email: 'marusa@example.com', password: 'trainerjim', full_name: 'Marusa', trainer: trainer)
kristjan = User.create(email: 'kristjan.korez@example.com', password: 'trainerjim', full_name: 'Kristjan', is_trainer: true)

core = ExerciseGroup.create(name: 'Core')
arms = ExerciseGroup.create(name: 'Arms')
legs = ExerciseGroup.create(name: 'Legs')
back = ExerciseGroup.create(name: 'Back')

free_weights = ExerciseGroup.create(name: 'Weights', is_machine_group: true)
bench_group = ExerciseGroup.create(name: 'Bench', is_machine_group: true)
body_weight = ExerciseGroup.create(name: 'Body', is_machine_group: true)
machine = ExerciseGroup.create(name: 'Machine', is_machine_group: true)
mat = ExerciseGroup.create(name: 'Mat', is_machine_group: true)

bench = ExerciseType.create(name: 'Bench press', exercise_groups: [arms, back, bench_group])
incline = ExerciseType.create(name: 'Incline press', exercise_groups: [arms, machine])
vertical = ExerciseType.create(name: 'Shoulder press', exercise_groups: [arms, machine])
lat = ExerciseType.create(name: 'Lat machine', exercise_groups: [machine])
leg = ExerciseType.create(name: 'Leg press', exercise_groups: [legs, machine])
triceps = ExerciseType.create(name: 'Triceps', exercise_groups: [arms, free_weights, body_weight, bench_group])
biceps = ExerciseType.create(name: 'Biceps', exercise_groups: [arms, free_weights, body_weight])
squats = ExerciseType.create(name: 'Squats', exercise_groups: [legs, body_weight])
back_curl = ExerciseType.create(name: 'Back curl', exercise_groups: [back, mat])


# Create some dummy trainings:
training1 = Training.create(name: 'Super training')
training1_ex1 = training1.exercises.create(:exercise_type => bench, :order => 1, :machine_setting => '1')
training1_ex2 = training1.exercises.create(:exercise_type => incline, :order => 2, :machine_setting => 'A')
training1_ex3 = training1.exercises.create(:exercise_type => vertical, :order => 3)
training1_ex4 = training1.exercises.create(:exercise_type => lat, :order => 4)
training1_ex5 = training1.exercises.create(:exercise_type => leg, :order => 5)
training1_ex6 = training1.exercises.create(:exercise_type => triceps, :order => 6)

training1_ex1.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex1.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 15)
training1_ex1.series.create(:order => 3, :repeat_count => 10, :weight => 45)

training1_ex2.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 17)
training1_ex2.series.create(:order => 2, :repeat_count => 15, :weight => 55)
training1_ex2.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 25)

training1_ex3.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex3.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 13)
training1_ex3.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 9)

training1_ex4.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 27)
training1_ex4.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 18)
training1_ex4.series.create(:order => 3, :repeat_count => 10, :weight => 45)


training1 = Training.create(name: 'One more training')
training1_ex1 = training1.exercises.create(:exercise_type => bench, :order => 1)
training1_ex2 = training1.exercises.create(:exercise_type => incline, :order => 2)
training1_ex3 = training1.exercises.create(:exercise_type => incline, :order => 3)
training1_ex4 = training1.exercises.create(:exercise_type => lat, :order => 4)

training1_ex1.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex1.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 15)
training1_ex1.series.create(:order => 3, :repeat_count => 10, :weight => 45)

training1_ex2.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 17)
training1_ex2.series.create(:order => 2, :repeat_count => 15, :weight => 55)
training1_ex2.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 25)

training1_ex3.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex3.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 13)
training1_ex3.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 9)

training1_ex4.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 27)
training1_ex4.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 18)
training1_ex4.series.create(:order => 3, :repeat_count => 10, :weight => 45)


training1 = Training.create(name: 'This is a training indeed')
training1_ex1 = training1.exercises.create(:exercise_type => bench, :order => 1)
training1_ex2 = training1.exercises.create(:exercise_type => incline, :order => 2)
training1_ex3 = training1.exercises.create(:exercise_type => incline, :order => 3)
training1_ex4 = training1.exercises.create(:exercise_type => lat, :order => 4)

training1_ex1.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex1.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 15)
training1_ex1.series.create(:order => 3, :repeat_count => 10, :weight => 45)

training1_ex2.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 17)
training1_ex2.series.create(:order => 2, :repeat_count => 15, :weight => 55)
training1_ex2.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 25)

training1_ex3.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex3.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 13)
training1_ex3.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 9)

training1_ex4.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 27)
training1_ex4.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 18)
training1_ex4.series.create(:order => 3, :repeat_count => 10, :weight => 45)


training1 = Training.create(name: 'What a training!')
training1_ex1 = training1.exercises.create(:exercise_type => bench, :order => 1)
training1_ex2 = training1.exercises.create(:exercise_type => incline, :order => 2)
training1_ex3 = training1.exercises.create(:exercise_type => incline, :order => 3)
training1_ex4 = training1.exercises.create(:exercise_type => lat, :order => 4)

training1_ex1.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex1.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 15)
training1_ex1.series.create(:order => 3, :repeat_count => 10, :weight => 45)

training1_ex2.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 17)
training1_ex2.series.create(:order => 2, :repeat_count => 15, :weight => 55)
training1_ex2.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 25)

training1_ex3.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex3.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 13)
training1_ex3.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 9)

training1_ex4.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 27)
training1_ex4.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 18)
training1_ex4.series.create(:order => 3, :repeat_count => 10, :weight => 45)

training1 = Training.create(name: 'All tempo', :trainee => marusa)
training1_ex1 = training1.exercises.create(:exercise_type => bench, :order => 1, :machine_setting => '6')
training1_ex2 = training1.exercises.create(:exercise_type => incline, :order => 2)
training1_ex3 = training1.exercises.create(:exercise_type => incline, :order => 3, :machine_setting => 'B')
training1_ex4 = training1.exercises.create(:exercise_type => lat, :order => 4)

training1_ex1.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex1.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 15)
training1_ex1.series.create(:order => 3, :repeat_count => 10, :weight => 45)

training1_ex2.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 17)
training1_ex2.series.create(:order => 2, :repeat_count => 15, :weight => 55)
training1_ex2.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 25)

training1_ex3.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex3.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 13)
training1_ex3.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 9)

training1_ex4.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 27)
training1_ex4.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 18)
training1_ex4.series.create(:order => 3, :repeat_count => 10, :weight => 45)


training1 = Training.create(name: 'Spring fat trim', :trainee => marusa)
training1_ex1 = training1.exercises.create(:exercise_type => bench, :order => 1)
training1_ex2 = training1.exercises.create(:exercise_type => incline, :order => 2, :machine_setting => 'C')
training1_ex3 = training1.exercises.create(:exercise_type => incline, :order => 3)
training1_ex4 = training1.exercises.create(:exercise_type => lat, :order => 4, :machine_setting => '4')

training1_ex1.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex1.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 15)
training1_ex1.series.create(:order => 3, :repeat_count => 10, :weight => 45)

training1_ex2.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 17)
training1_ex2.series.create(:order => 2, :repeat_count => 15, :weight => 55)
training1_ex2.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 25)

training1_ex3.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex3.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 13)
training1_ex3.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 9)

training1_ex4.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 27)
training1_ex4.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 18)
training1_ex4.series.create(:order => 3, :repeat_count => 10, :weight => 45)


training1 = Training.create(name: 'Summer action', :trainee => marusa)
training1_ex1 = training1.exercises.create(:exercise_type => bench, :order => 1)
training1_ex2 = training1.exercises.create(:exercise_type => incline, :order => 2)
training1_ex3 = training1.exercises.create(:exercise_type => incline, :order => 3)
training1_ex4 = training1.exercises.create(:exercise_type => lat, :order => 4)

training1_ex1_s1 = training1_ex1.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex1_s2 = training1_ex1.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 15)
training1_ex1_s3 = training1_ex1.series.create(:order => 3, :repeat_count => 10, :weight => 45)

training1_ex2.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 17)
training1_ex2.series.create(:order => 2, :repeat_count => 15, :weight => 55)
training1_ex2.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 25)

training1_ex3.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex3.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 13)
training1_ex3.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 9)

training1_ex4.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 27)
training1_ex4.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 18)
training1_ex4.series.create(:order => 3, :repeat_count => 10, :weight => 45)

db_shoulder_press = ExerciseType.create(name: 'Db shoulder press', exercise_groups: [bench_group, free_weights, arms])
triceps_push_down = ExerciseType.create(name: 'Triceps push down', exercise_groups: [arms, body_weight])
bic_cable_curl = ExerciseType.create(name: 'Biceps cable curl', exercise_groups: [arms, machine])
chest_butterfly = ExerciseType.create(name: 'Chest butterfly', exercise_groups: [body_weight])
mch_abd_crunch = ExerciseType.create(name: 'Mch abdominal crunch', exercise_groups: [core])
mch_bench_press = ExerciseType.create(name: 'Mc bench press', exercise_groups: [bench_group, arms])
lower_back = ExerciseType.create(name: 'Lower back', exercise_groups: [mat, back])
upper_back = ExerciseType.create(name: 'Upper back', exercise_groups: [mat, back])
free_ab_cruch = ExerciseType.create(name: 'Free abdominal crunch', exercise_groups: [core])

measurement = Measurement.create(
    trainee: igor,
    training: training1,
    start_time: DateTime.now.yesterday.ago(300),
    end_time: DateTime.now.yesterday,
    rating: 1,
    comment: 'This is a comment from my trainer. He is a nice guy.'
)

measurement.series_executions.create(
    measurement: measurement,
    series: training1_ex1_s1,
    num_repetitions: 10,
    weight: 90,
    rest_time: 90,
    duration_seconds: 40,
    rating: 1
)

measurement.series_executions.create(
    measurement: measurement,
    series: training1_ex1_s2,
    num_repetitions: 12,
    weight: 120,
    rest_time: 88,
    duration_seconds: 32,
    rating: 1
)

measurement.series_executions.create(
    measurement: measurement,
    series: training1_ex1_s3,
    num_repetitions: 10,
    weight: 33,
    rest_time: 32,
    duration_seconds: 78,
    rating: 1
)

measurement = Measurement.create(
    trainee: igor,
    training: training1,
    start_time: DateTime.now.ago(300),
    end_time: DateTime.now,
    rating: 2,
    comment: 'This is a comment from my trainer. He is a nice guy.'
)

measurement.series_executions.create(
    measurement: measurement,
    series: training1_ex1_s1,
    num_repetitions: 10,
    weight: 90,
    rest_time: 90,
    duration_seconds: 40,
    rating: 1
)

measurement.series_executions.create(
    measurement: measurement,
    series: training1_ex1_s2,
    num_repetitions: 12,
    weight: 120,
    rest_time: 88,
    duration_seconds: 32,
    rating: 1
)

measurement.series_executions.create(
    measurement: measurement,
    series: training1_ex1_s3,
    num_repetitions: 10,
    weight: 33,
    rest_time: 32,
    duration_seconds: 78,
    rating: 1
)

Measurement.create(trainee: trainer, training: training1, start_time: DateTime.now.ago(121300), end_time: DateTime.now.ago(121000), rating: 2, comment: 'This is a comment from myself.')
Measurement.create(trainee: kristjan, training: training1, start_time: DateTime.now.ago(121300), end_time: DateTime.now.ago(121000), rating: 2, comment: 'This is a comment from myself.')
Measurement.create(trainee: marusa, training: training1, start_time: DateTime.now.ago(121300), end_time: DateTime.now.ago(121000), rating: 2, comment: 'This is a comment from myself.')
Measurement.create(trainee: blaz, training: training1, start_time: DateTime.now.ago(121300), end_time: DateTime.now.ago(121000), rating: 2, comment: 'This is a comment from myself.')
Measurement.create(trainee: matej, training: training1, start_time: DateTime.now.ago(121300), end_time: DateTime.now.ago(121000), rating: 2, comment: 'This is a comment from myself.')
Measurement.create(trainee: damjan, training: training1, start_time: DateTime.now.ago(121300), end_time: DateTime.now.ago(121000), rating: 2, comment: 'This is a comment from myself.')

####################### AUTOMATED TESTING SEEDS
# This seeds are only for automated tests purposes and shouldn't be changed
autotest_user = User.create(:email => 'auto@test.user', :password => 'valid_pass', :full_name => 'AutoTest')

db_shoulder_press = ExerciseType.create(name: 'Db shoulder press', exercise_groups: [arms, body_weight])

Training.record_timestamps = false
training1 = Training.create(name: 'Summer action', :trainee => autotest_user, :created_at => '1/2/2012'.to_date, :updated_at => '1/2/2012'.to_date)
training1_ex1 = training1.exercises.create(:exercise_type => bench, :order => 1)
training1_ex2 = training1.exercises.create(:exercise_type => incline, :order => 2)
training1_ex3 = training1.exercises.create(:exercise_type => incline, :order => 3)
training1_ex4 = training1.exercises.create(:exercise_type => lat, :order => 4)

training1_ex1.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex1.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 15)
training1_ex1.series.create(:order => 3, :repeat_count => 10, :weight => 45)

training1_ex2.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 17)
training1_ex2.series.create(:order => 2, :repeat_count => 15, :weight => 55)
training1_ex2.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 25)

training1_ex3.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex3.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 13)
training1_ex3.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 9)

training1_ex4.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 27)
training1_ex4.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 18)
training1_ex4.series.create(:order => 3, :repeat_count => 10, :weight => 45)

training1 = Training.create(name: 'Spring fat trim', :trainee => autotest_user, :created_at => '1/3/2012'.to_date, :updated_at => '1/3/2012'.to_date)
training1_ex1 = training1.exercises.create(:exercise_type => bench, :order => 1)
training1_ex2 = training1.exercises.create(:exercise_type => incline, :order => 2, :machine_setting => 'C')
training1_ex3 = training1.exercises.create(:exercise_type => incline, :order => 3)
training1_ex4 = training1.exercises.create(:exercise_type => lat, :order => 4, :machine_setting => '4')

training1_ex1.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex1.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 15)
training1_ex1.series.create(:order => 3, :repeat_count => 10, :weight => 45)

training1_ex2.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 17)
training1_ex2.series.create(:order => 2, :repeat_count => 15, :weight => 55)
training1_ex2.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 25)

training1_ex3.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex3.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 13)
training1_ex3.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 9)

training1_ex4.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 27)
training1_ex4.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 18)
training1_ex4.series.create(:order => 3, :repeat_count => 10, :weight => 45)

Training.record_timestamps = true

training1 = Training.create(name: 'Summer action', :trainee => igor)
training1_ex1 = training1.exercises.create(:exercise_type => bench, :order => 1)
training1_ex2 = training1.exercises.create(:exercise_type => incline, :order => 2)
training1_ex3 = training1.exercises.create(:exercise_type => incline, :order => 3)
training1_ex4 = training1.exercises.create(:exercise_type => lat, :order => 4)

training1_ex1.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex1.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 15)
training1_ex1.series.create(:order => 3, :repeat_count => 10, :weight => 45)

training1_ex2.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 17)
training1_ex2.series.create(:order => 2, :repeat_count => 15, :weight => 55)
training1_ex2.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 25)

training1_ex3.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex3.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 13)
training1_ex3.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 9)

training1_ex4.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 27)
training1_ex4.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 18)
training1_ex4.series.create(:order => 3, :repeat_count => 10, :weight => 45)

######################## END AUTOMATED TESTING SEEDS

User.update_all(:confirmed_at => Time.now)