# config valid only for current version of Capistrano
lock '3.5.0'

set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }
#set :whenever_command, "bundle exec whenever"

set :application, 'purple'
set :scm, :git
set :repo_url, 'git@code.osu.edu:osul-ads/purple.git'

# Default branch is master
set :branch, ENV['BRANCH'] || "master"

set :rvm_ruby_version, 'ruby-2.3.1'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/purple"
set :tmp_dir, "/var/www/tmp"

set :linked_files, %w(.env public/sitemap.xml.gz config/analytics.yml config/blacklight.yml config/database.yml config/fedora.yml config/redis.yml config/solr.yml config/handle_server.yml)
set :linked_dirs, %w(log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets)

set :pty, false

set :monit_services, [:sidekiq]

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: 'log/capistrano.log', color: :auto, truncate: :auto

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Deployment Tasks
# ==================
namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      execute "mkdir -p #{release_path.join('tmp')}"
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  # Deployment Hooks
  after :publishing, :restart
end
