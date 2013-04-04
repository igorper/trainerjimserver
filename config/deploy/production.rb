role :web, "demo.trainerjim.com"
role :app, "demo.trainerjim.com"
role :db,  "demo.trainerjim.com", :primary => true

set :rails_env, 'production'
set :branch, 'stable'
set :port, 59937