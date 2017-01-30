require 'rails_helper'

RSpec.describe Property do
  let(:controller) { CatalogController.new }

  describe '.FIELDS' do
    it 'includes all the fields that can be queried' do
      expected_fields = %w(archival_unit collection_identifier)
      expect(described_class::FIELDS.keys).to match_array expected_fields
    end
  end

  describe '.all' do
    it 'returns a Property object for each field' do
      expect(described_class.all.count).to be described_class::FIELDS.count
      expect(described_class.all.first). to be_a described_class
      expect(described_class.all.first.name).to eq described_class::FIELDS.keys.first
    end
  end

  # describe '.find' do
  #   let(:field) { 'collection_identifier' }
  #   let(:values) { %w(ABC.123 FOO.456) }

  #   before do
  #     create(:work, field => values[0])
  #     create(:work, field => values[1])
  #     configure_class
  #   end

  #   it 'returns a Property containing all values of the field' do
  #     property = described_class.find field

  #     expect(property).to be_a described_class
  #     expect(property.name).to eq field
  #     expect(property.values).to match_array values
  #   end
  # end

  def configure_class
    described_class.repository = controller.repository
    described_class.search_builder = controller.search_builder
  end
end
