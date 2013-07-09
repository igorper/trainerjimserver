role :web, "matej.trainerjim.com"
role :app, "matej.trainerjim.com"
role :db,  "matej.trainerjim.com", :primary => true

set :rails_env, 'matej'
set :repository, "git@bitbucket.org:urbas/trainerjimserver.git"
set :branch, 'per-developer-deployments'

# role :web, "localhost"
# role :app, "localhost"
# role :db,  "localhost", :primary => true
# 
# set :rails_env, 'staging'
# set :repository, '/home/matej/Documents/Programming/trainerjimserver'
# set :branch, 'matej'