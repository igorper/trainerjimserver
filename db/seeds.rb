# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

matej = User.create(:email => 'matej.urbas@gmail.com', :password => 'Hrt 2309_Vili', :admin => true, :full_name => 'Matej Urbas')
igor = User.create(:email => 'igor.pernek@gmail.com', :password => '307 Lakih_Pet', :admin => true, :full_name => 'Igor Pernek')
damjan = User.create(:email => 'damjan.obal@gmail.com', :password => 'Klipni_Ul 103', :admin => true, :full_name => 'Damjan Obal')
kristjan = User.create(:email => 'kristjan.korez@gmail.com', :password => 'korezina 371', :admin => true, :full_name => 'Kristjan Korez')


# Create a dummy training for Igor:
training1 = Training.create(:name => 'Super Trening')
training1_ex1 = training1.exercises.create(:name => 'Bench Press', :order => 1)
training1_ex2 = training1.exercises.create(:name => 'Incline Press', :order => 2)
training1_ex3 = training1.exercises.create(:name => 'Vertical Press', :order => 3)
training1_ex4 = training1.exercises.create(:name => 'Lat Pulldown', :order => 4)

training1_ex1.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex1.series.create(:order => 2, :repeat_count => 15, :weight => 55)
training1_ex1.series.create(:order => 3, :repeat_count => 10, :weight => 45)

training1_ex2.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex2.series.create(:order => 2, :repeat_count => 15, :weight => 55)
training1_ex2.series.create(:order => 3, :repeat_count => 10, :weight => 45)

training1_ex3.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex3.series.create(:order => 2, :repeat_count => 15, :weight => 55)
training1_ex3.series.create(:order => 3, :repeat_count => 10, :weight => 45)

training1_ex4.series.create(:order => 1, :repeat_count => 10, :weight => 50)
training1_ex4.series.create(:order => 2, :repeat_count => 15, :weight => 55)
training1_ex4.series.create(:order => 3, :repeat_count => 10, :weight => 45)