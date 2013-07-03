namespace :db do
  
  desc "Drops the database, creates it again and adds initial data into the DB."
  task :recreate => :environment do
    Rake::Task['db:drop'].invoke
    Rake::Task['db:prepare'].invoke
  end
  
  desc "Creates the database and adds initial data into the DB."
  task :prepare => :environment do
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:bootstrap'].invoke
  end
  
  desc "Adds initial data into the DB (unlike db:seed this one adds data common to production and development)."
  task :bootstrap => :environment do
    # ROLE: Add the admin and trainer roles:
    Role.create(:name => Role.administrator)
    Role.create(:name => Role.trainer)
  end
  
end