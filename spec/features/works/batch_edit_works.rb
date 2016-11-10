require 'rails_helper'

RSpec.feature 'Batch Edit GenericWorks' do
  context 'as a logged in user' do
    let(:unit) { create(:unit) }
    let(:user) { create(:user, unit: unit) }
    let!(:work1) { create(:generic_work, unit: unit.key, user: user) }
    let!(:work2) { create(:generic_work, unit: unit.key, user: user) }

    before do
      login_as user
    end

    scenario 'batch edit descriptions', js: true do
      visit sufia.dashboard_works_path
      check 'check_all'
      find_button('Edit Selected').click
      click_on 'expand_link_contributor'
      fill_in 'generic_work[contributor][]', with: 'A Smart Contributor'
      click_button 'Save changes'
      wait_for_ajax

      work1.reload
      work2.reload
      expect(work1.contributor).to eq ['A Smart Contributor']
      expect(work2.contributor).to eq ['A Smart Contributor']
    end

    scenario 'batch edit permissions', js: true do
      visit sufia.dashboard_works_path
      check 'check_all'
      find_button('Edit Selected').click
      click_on 'Permissions'
      choose 'Public'
      click_button 'Save changes'
      wait_for_ajax

      work1.reload
      work2.reload
      expect(work1.visibility).to eq 'open'
      expect(work2.visibility).to eq 'open'
    end
  end
end
