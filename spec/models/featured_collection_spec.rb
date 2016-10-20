require 'rails_helper'

RSpec.describe FeaturedCollection, type: :model do
  describe "validation" do
    it { is_expected.to validate_inclusion_of(:order).in_range(0..described_class::FEATURE_LIMIT) }

    it 'validates the featured collection count is within limits' do
      allow(described_class).to receive(:count).and_return(5)
      featured = build(:featured_collection)
      expect(featured).to be_invalid
    end
  end

  describe ".can_create_another?" do
    it 'return false if there are too many featured collections' do
      allow(described_class).to receive(:count).and_return(5)
      expect(described_class.can_create_another?).to be false
    end
  end
end
