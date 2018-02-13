require 'rails_helper'

RSpec.describe PropertySearchBuilder do
  subject { described_class.new(scope).with(params) }
  let(:params) { {} }

  let(:user) { create(:user) }
  let(:config) { CatalogController.blacklight_config }
  let(:scope) do
    instance_double('The scope',
                    blacklight_config: config,
                    params: {},
                    current_ability: Ability.new(user),
                    current_user: user)
  end

  describe '.default_processor_chain' do
    it 'contains the includes and facte query processors' do
      expect(described_class.default_processor_chain).to include(:includes_filter, :facet_query_params)
    end
  end

  describe '#includes_filter' do
    let(:filter) { 'my_filter' }
    let(:params) { { includes: filter } }

    it 'adds the includes parameter to the filter queries' do
      expect(subject.processed_parameters[:fq]).to include(filter)
    end
  end
end
