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

  config.before :each do
    DatabaseCleaner.strategy = if Capybara.current_driver == :rack_test
                                 :transaction
                               else
                                 :truncation
                               end

    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
