require 'rails_helper'

RSpec.describe SufiaHelper do
  describe 'modules' do
    it { is_expected.to include_module(::BlacklightHelper) }
    it { is_expected.to include_module(Sufia::BlacklightOverride) }
    it { is_expected.to include_module(Sufia::SufiaHelperBehavior) }
  end
end
