set :stages, %w(production staging localdev matej)
set :default_stage, 'staging'
require 'capistrano/ext/multistage'

set :application, "TrainerJim"
set :repository, "git@bitbucket.org:urbas/trainerjimserver.git"
set :scm, 'git'

set :rails_env, 'production'

set :deploy_to, "/maco/rails/deployments/#{application}"
set :user, 'root'
set :use_sudo, false

# START: RVM stuff
# NOTE: Install 'gem install rvm-capistrano' on the server!
set :rvm_type, :system

require 'rvm/capistrano'
# END: RVM stuff


after 'bundle:install', 'deploy:migrate'

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