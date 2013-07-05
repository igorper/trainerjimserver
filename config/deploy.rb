set :stages, %w(production staging localdev rok igor matej dev)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

set :application, "TrainerJim"
set :repository, "git@bitbucket.org:trainerjim/trainerjimserver.git"
set :scm, 'git'


set(:deploy_to) { "/maco/rails/deployments/#{application}/#{stage}" }
set :user, 'root'
set :use_sudo, false

# START: RVM stuff
# NOTE: Install 'gem install rvm-capistrano' on the server!
set :rvm_type, :system

require 'rvm/capistrano'
# END: RVM stuff


# START: Passenger-specific stuff:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
# END: Passenger-specific stuff:

require 'bundler/capistrano'


namespace :do do  
  desc "Run a task on a remote server."  
  # run like: cap staging do:invoke task=a_certain_task  
  task :invoke do  
    run("cd #{deploy_to}/current; #{rake} RAILS_ENV=#{rails_env} #{ENV['task']}")
  end  
end

# START: We have to create the database first on cold deployment:
namespace :deploy do
  task :default do
    update
    migrate
    restart
  end
  
  task :bootstrap do
    update
    my_bootstrap
    migrate
    restart
  end

  task :my_bootstrap, :roles => :app do
    run "cd #{current_path}; #{rake} RAILS_ENV=#{rails_env} db:create db:migrate db:bootstrap"
  end
end