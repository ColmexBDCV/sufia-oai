Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec::Matchers.define :include_module do |expected|
  match do
    described_class.included_modules.include?(expected)
  end

  description do
    "include the #{expected} module"
  end

  failure_message do
    "expected #{described_class} to include the #{expected} module"
  end
end
