require 'rails_helper'

RSpec.describe OaiSet do
  describe '.all' do
    it 'returns all visible units' do
      create(:unit)
      create(:unit, key: 'foo', name: 'Foo')

      sets = described_class.all
      expect(sets.count).to be 2
      expect(sets.first).to be_a Unit
    end
  end

  describe '.from_spec' do
    context 'with a valid spec' do
      let(:spec) { 'unit:myunit' }

      it 'returns the filter query' do
        expect(described_class.from_spec(spec)).to eq 'unit_ssim:myunit'
      end
    end

    context 'with an invalid prefix' do
      let(:spec) { 'foo:myunit' }

      it 'raises an argument exception' do
        expect { described_class.from_spec(spec) }.to raise_error(::OAI::ArgumentException)
      end
    end

    context 'with an invalid spec' do
      let(:spec) { 'invalid' }

      it 'raises an argument exception' do
        expect { described_class.from_spec(spec) }.to raise_error(::OAI::ArgumentException)
      end
    end
  end
end
