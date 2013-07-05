role :web, "rok.trainerjim.com"
role :app, "rok.trainerjim.com"
role :db,  "rok.trainerjim.com", :primary => true

set :rails_env, 'rok'
set :repository, "git@bitbucket.org:rokstrnisa/trainerjimserver.git"