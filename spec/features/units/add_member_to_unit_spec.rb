require 'rails_helper'

RSpec.feature 'Add member to Unit' do
  let(:unit) { create(:unit) }
  let(:user) { create(:admin_user) }

  context 'as a logged in user', js: true do
    before do
      login_as user
    end

    scenario "can add units" do
      visit edit_unit_path(unit)

      expect(page).to have_text 'Edit My Unit'
      # click_link 'Add member to unit'
      # expect(page).to have_text 'test'
      # select user.name, from: 'User'
      # select 'Manager', from: 'Level'
      # click_button 'Update Unit'
      # expect(page).to have_text 'test'

      # expect(page).to have_content user.name
    end
  end
end
