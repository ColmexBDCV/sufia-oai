require 'rails_helper'

RSpec.feature 'Add member to Unit' do
  let(:unit) { create(:unit) }
  let(:user) { create(:user) }

  context 'as a logged in user' do
    before do
      login_as user
    end

    scenario do
      visit edit_unit_path(unit)
      select user.name, from: 'User'
      fill_in 'Level', with: 'Manager'
      click_button 'Add'

      expect(page).to have_content user.name
    end
  end
end
