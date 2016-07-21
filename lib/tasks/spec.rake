require 'rspec/core'
require 'rspec/core/rake_task'
require 'solr_wrapper'
require 'fcrepo_wrapper'
require 'active_fedora/rake_support'

Rake::Task['spec'].clear

desc 'Spin up test servers and run all specs'
task :spec do
  test_server do
    Rake::Task['spec:all'].invoke
  end
end

task :spec_ci do
  ci_server do
    Rake::Task['spec:all'].invoke
  end
end

namespace :spec do
  desc 'Run all specs (without backing services)'
  task :all do
    RSpec::Core::RakeTask.new('spec:all')
  end
end

private
def test_server(&block)
  wrapper("test.yml", &block)
end

def ci_server(&block)
  wrapper("test_ci.yml", &block)
end

def wrapper(config)
  return yield if ENV["TEST_SERVER_STARTED"]

  ENV["TEST_SERVER_STARTED"] = 'true'

  SolrWrapper.wrap({:config=>"config/solr_wrapper_#{config}"}) do |solr|
    ENV["SOLR_TEST_PORT"] = solr.port.to_s
    solr_config_path = File.join('solr', 'config')
    # Check to see if configs exist in a path relative to the working directory
    unless Dir.exist?(solr_config_path)
      $stderr.puts "Solr configuration not found at #{solr_config_path}. Using ActiveFedora defaults"
      # Otherwise use the configs delivered with ActiveFedora.
      solr_config_path = File.join(File.expand_path("../..", File.dirname(__FILE__)), "solr", "config")
    end
    solr.with_collection(name: "hydra-test", dir: solr_config_path) do
      FcrepoWrapper.wrap({:config=>"config/fcrepo_wrapper_#{config}"}) do |fcrepo|
        ENV["FCREPO_TEST_PORT"] = fcrepo.port.to_s
        yield
      end
    end
  end

  ENV["TEST_SERVER_STARTED"] = 'false'
end
