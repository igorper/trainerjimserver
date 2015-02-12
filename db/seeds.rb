# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin_role = Role.find_by_name(Role.administrator)
trainer_role = Role.find_by_name(Role.trainer)

trainer = User.create(:email => 'jim@example.com', :password => 'trainerjim', :full_name => 'Jim the Trainer', :roles => [trainer_role])
matej = User.create(:email => 'matej.urbas@gmail.com', :password => 'trainerjim', :full_name => 'Matej', :roles => [admin_role], :trainer => trainer)
igor = User.create(:email => 'igor.pernek@gmail.com', :password => 'trainerjim', :full_name => 'Igor', :roles => [admin_role], :trainer => trainer)
damjan = User.create(:email => 'damjan.obal@example.com', :password => 'trainerjim', :full_name => 'Damjan', :roles => [admin_role], :trainer => trainer)
blaz = User.create(:email => 'snuderl@example.com', :password => 'trainerjim', :full_name => 'Blaz', :roles => [admin_role], :trainer => trainer)
marusa = User.create(:email => 'marusa@example.com', :password => 'trainerjim', :full_name => 'Marusa', :roles => [], :trainer => trainer)
kristjan = User.create(:email => 'kristjan.korez@example.com', :password => 'trainerjim', :full_name => 'Kristjan', :roles => [trainer_role])

bench = ExerciseType.create(:name => "Bench press")
incline = ExerciseType.create(:name => "Incline press")
vertical = ExerciseType.create(:name => "Shoulder press")
lat = ExerciseType.create(:name => "Lat machine")
leg = ExerciseType.create(:name => "Leg press")
triceps = ExerciseType.create(:name => "Triceps")
biceps = ExerciseType.create(:name => "Biceps")


# Create some dummy trainings:
training1 = Training.create(:name => 'Super training')
training1_ex1 = training1.exercises.create(:exercise_type => bench, :order => 1, :machine_setting => "1")
training1_ex2 = training1.exercises.create(:exercise_type => incline, :order => 2, :machine_setting => "A")
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


training1 = Training.create(:name => 'One more training')
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


training1 = Training.create(:name => 'This is a training indeed')
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


training1 = Training.create(:name => 'What a training!')
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

training1 = Training.create(:name => 'All tempo', :trainee => marusa)
training1_ex1 = training1.exercises.create(:exercise_type => bench, :order => 1, :machine_setting => "6")
training1_ex2 = training1.exercises.create(:exercise_type => incline, :order => 2)
training1_ex3 = training1.exercises.create(:exercise_type => incline, :order => 3, :machine_setting => "B")
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


training1 = Training.create(:name => 'Spring fat trim', :trainee => marusa)
training1_ex1 = training1.exercises.create(:exercise_type => bench, :order => 1)
training1_ex2 = training1.exercises.create(:exercise_type => incline, :order => 2, :machine_setting => "C")
training1_ex3 = training1.exercises.create(:exercise_type => incline, :order => 3)
training1_ex4 = training1.exercises.create(:exercise_type => lat, :order => 4, :machine_setting => "4")

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


training1 = Training.create(:name => 'Summer action', :trainee => marusa)
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

db_shoulder_press = ExerciseType.create(:name => "Db shoulder press")
triceps_push_down = ExerciseType.create(:name => "Triceps push down")
bic_cable_curl = ExerciseType.create(:name => "Biceps cable curl")
chest_butterfly = ExerciseType.create(:name => "Chest butterfly")
mch_abd_crunch = ExerciseType.create(:name => "Mch abdominal crunch")
mch_bench_press = ExerciseType.create(:name => "Mc bench press")
lower_back = ExerciseType.create(:name => "Lower back")
upper_back = ExerciseType.create(:name => "Upper back")
free_ab_cruch = ExerciseType.create(:name => "Free abdominal crunch")

measurement = Measurement.create(
    trainee: igor,
    trainer: trainer,
    training: training1,
    data: 'somedata',
    start_time: DateTime.now.yesterday.ago(300),
    end_time: DateTime.now.yesterday,
    rating: 1,
    trainer_seen: true,
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
    trainer: trainer,
    training: training1,
    data: 'somedata',
    start_time: DateTime.now.ago(300),
    end_time: DateTime.now,
    rating: 2,
    trainer_seen: true,
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

####################### AUTOMATED TESTING SEEDS
# This seeds are only for automated tests purposes and shouldn't be changed
autotest_user = User.create(:email => 'auto@test.user', :password => 'valid_pass', :full_name => 'AutoTest', :roles => [])

db_shoulder_press = ExerciseType.create(:name => "Db shoulder press")

Training.record_timestamps = false
training1 = Training.create(:name => 'Summer action', :trainee => autotest_user, :created_at => '1/2/2012'.to_date, :updated_at => '1/2/2012'.to_date)
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

training1 = Training.create(:name => 'Spring fat trim', :trainee => autotest_user, :created_at => '1/3/2012'.to_date, :updated_at => '1/3/2012'.to_date)
training1_ex1 = training1.exercises.create(:exercise_type => bench, :order => 1)
training1_ex2 = training1.exercises.create(:exercise_type => incline, :order => 2, :machine_setting => "C")
training1_ex3 = training1.exercises.create(:exercise_type => incline, :order => 3)
training1_ex4 = training1.exercises.create(:exercise_type => lat, :order => 4, :machine_setting => "4")

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

training1 = Training.create(:name => 'Summer action', :trainee => igor)
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