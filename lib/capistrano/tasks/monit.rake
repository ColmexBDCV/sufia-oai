namespace :load do
  task :defaults do
    set :monit_role, :app
    set :monit_services, []
    set :monit_use_sudo, true
    set :monit_bin, '/usr/bin/monit'
    set :monit_default_hooks, true
  end
end

namespace :deploy do
  before :starting, :check_monit_hooks do
    if fetch(:monit_default_hooks)
      invoke 'monit:add_default_hooks'
    end
  end
end

namespace :monit do

  task :add_default_hooks do
    before 'deploy:updating',  'monit:stop'
    after  'deploy:published', 'monit:start'
  end

  desc 'Monitor services with monit'
  task :monitor do
    run_monit_command :monitor
  end

  desc 'Unmonitor services with monit'
  task :unmonitor do
    run_monit_command :unmonitor
  end

  desc 'Start services using monit'
  task :start do
    run_monit_command :start
  end

  desc 'Stop services using monit'
  task :stop do
    run_monit_command :stop
  end

  desc 'Restart services using monit'
  task :restart do
    run_monit_command :restart
  end

  def run_monit_command(argument)
    on roles(fetch(:monit_role)) do
      fetch(:monit_services).each do |service|
        sudo_if_needed "#{fetch(:monit_bin)} #{argument} #{service}"
      end
    end
  end

  def sudo_if_needed(command)
    send(use_sudo? ? :sudo : :execute, command)
  end

  def use_sudo?
    fetch(:monit_use_sudo)
  end

end
