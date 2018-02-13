require "rails_helper"
require 'requests/api/api_request'

RSpec.describe API::V1::PropertiesController do
  it_behaves_like 'api_request' do
    let(:path) { '/api/v1/properties' }
  end

  describe "index" do
    let(:path) { '/api/v1/properties.json' }
    before { get path }

    it 'returns the correct number of properties' do
      expect(parsed[:properties].count).to be 2
    end

    it 'returns each defined property' do
      expect(response.body).to include(*Property::FIELDS.keys)
    end
  end

  describe 'show' do
    let(:name) { 'collection_identifier' }
    let(:path) { "/api/v1/properties/#{name}.json" }

    it 'returns the specified property' do
      get path
      expect(parsed[:property][:name]).to eq name
    end

    context 'when the property has values' do
      let(:values) { %w(my_value another_value) }

      before do
        create(:work, :public, name => values[0])
        create(:work, :public, name => values[1])
      end

      it 'contains each value for the property' do
        get path
        expect(parsed[:property][:values]).to match_array values
      end

      context 'with an includes parameter' do
        let(:path) { "/api/v1/properties/#{name}.json?includes=other" }

        it 'only contains values with the parameter text' do
          get path
          expect(parsed[:property][:values]).to match_array [values[1]]
        end
      end
    end
  end

  def parsed
    JSON.parse(response.body, symbolize_names: true)
  end
end
