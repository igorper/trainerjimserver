role :web, "localhost"
role :app, "localhost"
role :db,  "localhost", :primary => true

set :rails_env, 'staging'
set :repository, '/home/matej/Documents/Programming/trainerjimserver'
set :branch, 'matej'