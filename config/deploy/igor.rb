role :web, "igor.trainerjim.com"
role :app, "igor.trainerjim.com"
role :db,  "igor.trainerjim.com", :primary => true

set :rails_env, 'igor'
set :repository, "git@bitbucket.org:igorper/trainerjimserver.git"