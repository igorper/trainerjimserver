role :web, "localhost"
role :app, "localhost"
role :db,  "localhost", :primary => true

set :rails_env, 'localdev'