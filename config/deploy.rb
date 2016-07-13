# config valid only for current version of Capistrano
lock '3.5.0'

set :application, 'dcs'
set :repo_url, 'git@code.osu.edu:osul-ads/purple.git'

# Default branch is master
set :branch, ENV['BRANCH'] || "master"

set :rvm_ruby_version, 'ruby-2.3.0'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/rails/apps/#{fetch(:application)}"
set :tmp_dir, "/home/rails/tmp/#{fetch(:application)}"

set :linked_files, %w{.env config/analytics.yml config/blacklight.yml config/database.yml config/fedora.yml config/redis.yml config/secrets.yml config/solr.yml}
set :linked_dirs, %w{ log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets}

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5


# Deployment Tasks
# ==================
namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "mkdir -p #{release_path.join('tmp')}"
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  # Deployment Hooks
  after :publishing, :restart
  after :restart, :ping

end
