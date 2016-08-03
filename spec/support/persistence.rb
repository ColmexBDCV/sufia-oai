require 'active_fedora/cleaner'

RSpec.configure do |config|
  config.before :suite do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before :each do |example|
    unless example.metadata[:type] == :view || example.metadata[:no_clean]
      ActiveFedora::Cleaner.clean!
    end
  end

  config.before :each do |example|
    if example.metadata[:type] == :feature && Capybara.current_driver != :rack_test
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
  end

  config.after do
    DatabaseCleaner.clean
  end
end
