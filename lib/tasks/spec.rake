require 'rspec/core'
require 'rspec/core/rake_task'
require 'solr_wrapper'
require 'fcrepo_wrapper'
require 'active_fedora/rake_support'

Rake::Task['spec'].clear

desc 'Spin up test servers and run all specs'
task :spec do
  with_test_server do
    Rake::Task['spec:all'].invoke
  end
end

namespace :spec do
  desc 'Run all specs (without backing services)'
  task :all do
    RSpec::Core::RakeTask.new('spec:all')
  end
end
