# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#if !User.find_by_email('matej.urbas@gmail.com') then

admin_role = Role.find_by_name(Role.administrator)
trainer_role = Role.find_by_name(Role.trainer)

trainer = User.create(:email => 'jim@jim.com', :password => 'trainerjim', :full_name => 'Jim the Trainer', :roles => [trainer_role])
matej = User.create(:email => 'matej.urbas@gmail.com', :password => 'Hrt 2309_Vili', :full_name => 'Matej', :roles => [admin_role], :trainer => trainer)
igor = User.create(:email => 'igor.pernek@gmail.com', :password => '307 Lakih_Pet', :full_name => 'Igor', :roles => [admin_role], :trainer => trainer)
damjan = User.create(:email => 'damjan.obal@gmail.com', :password => 'Klipni_Ul 103', :full_name => 'Damjan', :roles => [admin_role], :trainer => trainer)
blaz = User.create(:email => 'snuderl@gmail.com', :password => 'to je 5 vukov', :full_name => 'Blaz', :roles => [admin_role], :trainer => trainer)
marusa = User.create(:email => 'marusa@example.com', :password => 'test1234', :full_name => 'Marusa', :roles => [], :trainer => trainer)
kristjan = User.create(:email => 'kristjan.korez@gmail.com', :password => 'korezina 371', :full_name => 'Kristjan', :roles => [trainer_role])
#end

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

training1_ex1.series.create(:order => 1, :repeat_count => 10, :weight => 50, 
  :duration_after_repetition => 1500, :duration_up_repetition => 1000, :duration_middle_repetition => 0, 
  :duration_down_repetition => 2000)
training1_ex1.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 15, 
  :duration_after_repetition => 1500, :duration_up_repetition => 1000, :duration_middle_repetition => 0, 
  :duration_down_repetition => 2000)
training1_ex1.series.create(:order => 3, :repeat_count => 10, :weight => 45, 
  :duration_after_repetition => 1500, :duration_up_repetition => 1000, :duration_middle_repetition => 0, 
  :duration_down_repetition => 2000)

training1_ex2.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 17, 
  :duration_after_repetition => 1500, :duration_up_repetition => 1000, :duration_middle_repetition => 0, 
  :duration_down_repetition => 2000)
training1_ex2.series.create(:order => 2, :repeat_count => 15, :weight => 55, 
  :duration_after_repetition => 1500, :duration_up_repetition => 1000, :duration_middle_repetition => 0, 
  :duration_down_repetition => 2000)
training1_ex2.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 25, 
  :duration_after_repetition => 1500, :duration_up_repetition => 1000, :duration_middle_repetition => 0, 
  :duration_down_repetition => 2000)

training1_ex3.series.create(:order => 1, :repeat_count => 10, :weight => 50, 
  :duration_after_repetition => 1500, :duration_up_repetition => 1000, :duration_middle_repetition => 0, 
  :duration_down_repetition => 2000)
training1_ex3.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 13, 
  :duration_after_repetition => 1500, :duration_up_repetition => 1000, :duration_middle_repetition => 0, 
  :duration_down_repetition => 2000)
training1_ex3.series.create(:order => 3, :repeat_count => 10, :weight => 45, :rest_time => 9, 
  :duration_after_repetition => 1500, :duration_up_repetition => 1000, :duration_middle_repetition => 0, 
  :duration_down_repetition => 2000)

training1_ex4.series.create(:order => 1, :repeat_count => 10, :weight => 50, :rest_time => 27, 
  :duration_after_repetition => 1500, :duration_up_repetition => 1000, :duration_middle_repetition => 0, 
  :duration_down_repetition => 2000)
training1_ex4.series.create(:order => 2, :repeat_count => 15, :weight => 55, :rest_time => 18, 
  :duration_after_repetition => 1500, :duration_up_repetition => 1000, :duration_middle_repetition => 0, 
  :duration_down_repetition => 2000)
training1_ex4.series.create(:order => 3, :repeat_count => 10, :weight => 45, 
  :duration_after_repetition => 1500, :duration_up_repetition => 1000, :duration_middle_repetition => 0, 
  :duration_down_repetition => 2000)



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