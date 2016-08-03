RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :feature
  config.after(:each, type: :feature) { Warden.test_reset! }
end

OmniAuth.config.test_mode = true
