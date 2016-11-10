Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 30

Capybara.register_driver :poltergeist do |app|
  config = {
    timeout: 1.minute,
    phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'],
    url_blacklist: ['https://ssl.google-analytics.com', 'https://www.osu.edu']
  }

  Capybara::Poltergeist::Driver.new(app, config)
end

module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end
