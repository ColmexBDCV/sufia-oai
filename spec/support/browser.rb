Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 30

Capybara.register_driver :poltergeist do |app|
  config = {
    phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'],
    url_blacklist: ['https://ssl.google-analytics.com', 'https://www.osu.edu']
  }

  Capybara::Poltergeist::Driver.new(app, config)
end
