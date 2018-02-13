require 'rails_helper'

RSpec.describe Property do
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

  describe '.find' do
    let(:user) { User.new }
    let(:controller) { API::V1::PropertiesController.new }
    let(:field) { 'collection_identifier' }
    let(:values) { %w(ABC.123 FOO.456) }

    before do
      create(:work, :public, field => values[0])
      create(:work, :public, field => values[1])
      stub_controller
      configure_class
    end

    it 'returns a Property containing all values of the field' do
      property = described_class.find field

      expect(property).to be_a described_class
      expect(property.name).to eq field
      expect(property.values).to match_array values
    end

    context 'with an includes filter' do
      let(:params) { { includes: 'OO' } }

      it 'returns only values containing the filter text' do
        property = described_class.find field, params
        expect(property.values).to match_array [values[1]]
      end
    end
  end

  describe '#initialize' do
    let(:property) { described_class.new(hash) }
    let(:hash) { { ame: 'my_property', values: ['foo', 'bar'] } }

    it 'sets the name and values from a hash' do
      expect(property.name).to eq hash[:name]
      expect(property.values).to eq hash[:values]
    end
  end

  describe '#values=' do
    let(:property) { described_class.new }

    it 'is creates a values array from scalar input' do
      property.values = 'foo'
      expect(property.values).to eq ['foo']
    end
  end

  def stub_controller
    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:params).and_return({})
  end

  def configure_class
    described_class.repository = controller.repository
    described_class.search_builder = controller.search_builder
  end
end
