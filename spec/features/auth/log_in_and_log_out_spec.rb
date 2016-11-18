require 'rails_helper'

RSpec.feature 'User can log in and log out' do
  let!(:work) { create(:generic_work, :public) }
  let!(:user) { create(:user, email: 'foo@example.com', display_name: 'Test User') }
  let!(:identity) { create(:identity, uid: '1234', user: user, provider: 'default') }

  context 'as an anonymous user' do
    scenario 'when I log in, I am returned to the same page' do
      visit curation_concerns_generic_work_path(work)
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      click_button 'Log in'

      expect(page).to have_current_path curation_concerns_generic_work_path(work)
    end
  end

  context 'as a logged in user', js: true do
    before do
      login_as user
    end

    scenario do
      visit curation_concerns_generic_work_path(work)
      click_link user.display_name
      click_link 'Logout'

      expect(page).to have_current_path root_path
    end
  end
end
