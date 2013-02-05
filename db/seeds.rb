# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(:email => 'matej.urbas@gmail.com', :password => 'Hrt 2309_Vili', :admin => true, :first_name => 'Matej', :last_names => 'Urbas')
User.create(:email => 'igor.pernek@gmail.com', :password => '307 Lakih_Pet', :admin => true, :first_name => 'Igor', :last_names => 'Pernek')
User.create(:email => 'damjan.obal@gmail.com', :password => 'Klipni_Ul 103', :admin => true, :first_name => 'Damjan', :last_names => 'Obal')