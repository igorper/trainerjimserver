role :web, "trainerjim.banda.si"
role :app, "trainerjim.banda.si"
role :db,  "trainerjim.banda.si", :primary => true

set :rails_env, 'development'
set :user, 'trainerjim'
set :port, 465