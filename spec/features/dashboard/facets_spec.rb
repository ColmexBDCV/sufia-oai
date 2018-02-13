require 'rails_helper'

RSpec.feature 'Facet dashboard work list' do
  context 'as a logged in user' do
    let(:unit) { create(:unit) }
    let(:user) { create(:user, unit: unit) }
    let(:keywords) { %w(foo bar baz qux blah boo cashcats) }
    let!(:work) { create(:generic_work, unit: unit.key, user: user, keyword: keywords) }

    before do
      login_as user
    end

    scenario 'expanded facet on dashboard units path has correct keyword link', js: true do
      visit sufia.dashboard_units_path
      click_on 'Keyword'
      expect(page).to have_link('more Keywords»', href: '/dashboard/units/facet/keyword_sim')
    end

    scenario 'expanded facet on dashboard works path has correct keyword link', js: true do
      visit sufia.dashboard_works_path
      click_on 'Keyword'
      expect(page).to have_link('more Keywords»', href: '/dashboard/works/facet/keyword_sim')
    end
  end
end
