require 'rails_helper'

RSpec.describe Unit, type: :model do
  let(:unit) { build(:unit) }
  let(:key) { 'myunit' }
  let(:spec) { "unit:#{key}" }

  describe "validation" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:key) }
    it { is_expected.to allow_value('foo-1').for(:key) }
    it { is_expected.not_to allow_value('foo@s1').for(:key) }

    it 'validates that :key is case-sensitively unique' do
      create(:unit, key: key)
      unit = build(:unit, :allow_duplicate, name: 'Unit2', key: key)
      expect(unit).not_to be_valid
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:memberships).dependent(:destroy) }
    it { is_expected.to have_many(:members) }
    it { is_expected.to accept_nested_attributes_for(:memberships) }
  end

  describe '.spec_from_key' do
    it 'builds an OAI-PMH set spec given a unit key' do
      expect(described_class.spec_from_key(key)).to eq spec
    end
  end

  describe '#spec' do
    it 'returns an OAI-PMH set spec for the unit' do
      expect(unit.spec).to eq 'unit:myunit'
    end
  end
end
