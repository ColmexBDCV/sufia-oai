require 'rails_helper'

RSpec.feature 'Search the catalog' do
  context 'with several units' do
    let(:unit1) { create(:unit, key: 'unit1') }
    let(:unit2) { create(:unit, key: 'unit2') }
    let(:unit3) { create(:unit, key: 'unit3') }
    let(:unit4) { create(:unit, key: 'unit4') }
    let(:unit5) { create(:unit, key: 'unit5') }
    let(:unit6) { create(:unit, key: 'unit6') }

    before do
      create(:work, :public, unit: unit1.key)
      create(:work, :public, unit: unit2.key)
      create(:work, :public, unit: unit3.key)
      create(:work, :public, unit: unit4.key)
      create(:work, :public, unit: unit5.key)
      create(:work, :public, unit: unit6.key)
    end

    scenario 'search completes successfully' do
      visit search_catalog_path
      expect(page.status_code).to be 200
    end
  end
end
