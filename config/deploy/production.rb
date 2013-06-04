role :web, "www.trainerjim.com"
role :app, "www.trainerjim.com"
role :db,  "www.trainerjim.com", :primary => true

set :rails_env, 'production'
set :branch, 'stable'
#set :port, 59937