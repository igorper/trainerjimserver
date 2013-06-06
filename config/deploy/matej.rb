role :web, "localhost"
role :app, "localhost"
role :db,  "localhost", :primary => true

set :rails_env, 'localdev'
set :repository, '/home/matej/Documents/Programming/trainerjimserver'
set :branch, 'matej'