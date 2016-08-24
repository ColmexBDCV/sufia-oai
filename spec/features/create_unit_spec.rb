require 'rails_helper'

RSpec.feature 'Create a Unit' do
  context 'as a logged in user' do
    let(:user) { create(:admin_user) }

    before do
      login_as user
    end

    scenario do
      name = 'My Unit'

      visit new_unit_path
      fill_in 'Unit name', with: name
      fill_in 'Unit key', with: 'myunit'
      click_button 'Create'

      expect(page).to have_content name
    end
  end
end
