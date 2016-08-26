Capybara.javascript_driver = :webkit

Capybara::Webkit.configure do |config|
  config.block_unknown_urls
  config.ignore_ssl_errors
  config.skip_image_loading
end
