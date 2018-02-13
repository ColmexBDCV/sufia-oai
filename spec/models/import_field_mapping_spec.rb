require 'rails_helper'

RSpec.describe ImportFieldMapping, type: :model do
  it { should serialize(:value).as(Array) }

  describe 'associations' do
    it { is_expected.to belong_to(:import) }
  end

  describe '.initiate_mappings' do
    let(:import) { create(:import) }

    it 'creates mappings for an import for each field key' do
      expect {described_class.initiate_mappings(import)}.to change {import.import_field_mappings.count}.from(0).to(32)
    end
  end
end
