require 'rails_helper'

RSpec.feature 'Create a GenericWork' do
  context 'as a logged in user' do
    let(:unit) { create(:unit) }
    let(:user) { create(:user, unit: unit) }

    before do
      login_as user
    end

    scenario do
      visit new_curation_concerns_generic_work_path
      fill_in 'Title', with: 'Test GenericWork'
      fill_in 'Creator', with: 'Person, Test'
      fill_in 'Keyword', with: 'Test'
      select unit.name, from: 'Unit'
      find("#generic_work_rights").find(:xpath, 'option[1]').select_option
      click_on "Files"
      attach_file("files[]", Rails.root + 'spec/fixtures/cat.jpg')
      check 'agreement'
      click_button 'Save'

      expect(page).to have_content 'Test GenericWork'
    end
  end
end
