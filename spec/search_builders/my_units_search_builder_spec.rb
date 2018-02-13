require 'rails_helper'
require 'search_builders/concerns/has_logger'

RSpec.describe MyUnitsSearchBuilder do
  subject { described_class.new(scope) }

  let(:user) { create(:user) }
  let(:config) { CatalogController.blacklight_config }
  let(:scope) do
    instance_double('The scope',
                    blacklight_config: config,
                    params: {},
                    current_ability: Ability.new(user),
                    current_user: user)
  end

  describe 'modules' do
    it { is_expected.to include_module(Blacklight::Solr::SearchBuilderBehavior) }
    it { is_expected.to include_module(Hydra::AccessControlsEnforcement) }
    it { is_expected.to include_module(CurationConcerns::SearchFilters) }
    it { is_expected.to include_module(Hydra::PolicyAwareAccessControlsEnforcement) }
  end

  it_behaves_like "has_logger"

  describe '#discovery_permissions' do
    it 'only includes edit' do
      expect(subject.discovery_permissions).to contain_exactly('edit')
    end
  end

  describe '#only_works?' do
    it 'only searches works' do
      expect(subject.only_works?).to be true
    end
  end

  describe '.default_processor_chain' do
    it 'adds advanced searching' do
      expect(described_class.default_processor_chain).to include :add_advanced_search_to_solr
    end
  end
end
