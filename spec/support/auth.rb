require 'devise'

RSpec.configure do |config|
  config.include Warden::Test::Helpers, type: :feature
  config.after(:each, type: :feature) { Warden.test_reset! }
  config.include Devise::Test::ControllerHelpers, :type => :controller
end

OmniAuth.config.test_mode = true
