# Generated via
#  `rails generate curation_concerns:work GenericWork`
require 'rails_helper'
include Warden::Test::Helpers

Sidekiq.configure_client do |config|
  redis_config = YAML.load(ERB.new(IO.read(File.join(Rails.root, 'config', 'redis.yml'))).result)[Rails.env].with_indifferent_access
  config.redis = { url: "redis://#{redis_config[:host]}:6379/1", namespace: "cms_queues"}
end

RSpec.feature 'Create a GenericWork' do
  context 'a logged in user' do
    let(:user_attributes) do
      { email: 'test@example.com' }
    end
    let(:user) do
      User.new(user_attributes) { |u| u.save(validate: false) }
    end

    before do
      login_as user
    end

    scenario do
      visit new_curation_concerns_generic_work_path
      fill_in 'Title', with: 'Test GenericWork'
      fill_in 'Creator', with: 'Person, Test'
      fill_in 'Keyword', with: 'Test'
      check 'agreement'
      find("#generic_work_rights").find(:xpath, 'option[1]').select_option
      click_on "Files"
      attach_file("files[]", Rails.root + 'spec/fixtures/cat.jpg')
      click_button 'Save'
      expect(page).to have_content 'Test GenericWork'
    end
  end
end
