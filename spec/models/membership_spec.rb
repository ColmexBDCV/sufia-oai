require 'rails_helper'

RSpec.describe Membership, type: :model do
  let(:levels) { ['Manager', 'Curator', 'DataEntry'] }

  describe "validation" do
    it { is_expected.to validate_presence_of(:unit) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:level) }
    it { is_expected.to validate_inclusion_of(:level).in_array(levels) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:unit) }
  end

  describe '.levels' do
    it 'returns an array of all membership levels' do
      expect(described_class.levels).to eq levels
    end
  end
end
