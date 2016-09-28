Capybara.javascript_driver = :webkit

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
  config.ignore_ssl_errors
  config.skip_image_loading
end

# Capybara.register_driver :chrome do |app|
#   preferences = { "profile.managed_default_content_settings.images" => 2 }

#   caps = Selenium::WebDriver::Remote::Capabilities.chrome(
#     'chromeOptions' => {
#       'prefs' => preferences
#     }
#   )

#   Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: caps)
# end

# Capybara.javascript_driver = :chrome
