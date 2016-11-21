require 'rails_helper'

RSpec.describe UnitsHelper do
  describe 'unit_name' do
    let!(:unit) { create(:unit, name: 'The Unit', key: 'thekey') }

    context 'when argument is a unit key' do
      it 'returns the unit name for the given key' do
        expect(helper.unit_name('thekey')).to eq 'The Unit'
      end

      it 'returns nil of the unit does not exist' do
        expect(helper.unit_name('notakey')).to be_nil
      end
    end

    context 'when argument is a Unit' do
      it 'returns the unit name' do
        expect(helper.unit_name(unit)).to eq 'The Unit'
      end
    end
  end

  describe 'unit_catalog_path' do
    let(:unit) { build(:unit) }

    context 'when argument is a Unit' do
      it 'returns the path to the unit catalog page' do
        expect(helper.unit_catalog_path(unit)).to eq search_catalog_path(f: { 'unit_sim' => [unit.key] })
      end
    end

    context 'when argument is a unit key' do
      it 'returns the path to the unit catalog page for the given key' do
        expect(helper.unit_catalog_path(unit.key)).to eq search_catalog_path(f: { 'unit_sim' => [unit.key] })
      end
    end
  end
end
