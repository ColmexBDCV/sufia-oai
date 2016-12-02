require 'rails_helper'
require 'search_builders/concerns/has_logger'

RSpec.describe SearchBuilder do
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
end
