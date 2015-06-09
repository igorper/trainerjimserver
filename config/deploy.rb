# config valid only for current version of Capistrano
lock '3.4.0'

server_ip = '52.28.33.124'

set :application, 'trainerjimserver'
set :repo_url, 'git@bitbucket.org:trainerjim/trainerjimserver.git'

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.1.5'

# Default server configuration
role :app, ["trainerjim@#{server_ip}"]
role :web, ["trainerjim@#{server_ip}"]
role :db, ["trainerjim@#{server_ip}"]

server server_ip,
       user: 'trainerjim',
       roles: %w{web app db}

set :ssh_options, {
                    user: 'trainerjim',
                    keys: [ENV['HOME'] + '/.ssh/trainerjim_id_rsa'],
                    forward_agent: false,
                    auth_methods: %w(publickey)
                }

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/trainerjim/trainerjimserver-cap'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :linked_dirs, fetch(:linked_dirs, []).push('public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

task :stop_server do
  on roles(:web) do
    execute :sudo, :stop, fetch(:init_script)
  end
end

task :start_server do
  on roles(:web) do
    execute :sudo, :start, fetch(:init_script)
  end
end

task :restart_server do
  on roles(:web) do
    begin
      invoke :stop_server
      sleep 1
    rescue
      # ignored
    end
    invoke :start_server
  end
end

namespace :deploy do
  desc "build missing paperclip styles"
  task :build_missing_paperclip_styles do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "paperclip:refresh:missing_styles"
        end
      end
    end
  end
end

after("deploy:migrate", "deploy:build_missing_paperclip_styles")
after("deploy:finished", :restart_server)

namespace :deploy do

  # after :published, :restart_server do
  #   on roles(:web) do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end

end
