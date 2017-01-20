require 'rails_helper'

RSpec.describe OaiSearchBuilder do
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

  describe '#only_works?' do
    subject { described_class.new(scope).only_works? }
    it { is_expected.to be true }
  end
end
