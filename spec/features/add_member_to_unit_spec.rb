require 'rails_helper'

RSpec.feature 'Add member to Unit' do
  let(:unit) { create(:unit) }
  let(:user) { create(:admin_user) }

  context 'as a logged in user', js: true do
    before do
      login_as user
    end

    scenario do
      visit edit_unit_path(unit)
      click_link 'Add member to unit'
      select user.name, from: 'User'
      select 'Manager', from: 'Level'
      click_button 'Update Unit'

      expect(page).to have_content user.name
    end
  end
end
