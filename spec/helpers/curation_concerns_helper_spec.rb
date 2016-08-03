require 'rails_helper'

RSpec.describe CurationConcernsHelper do
  describe 'modules' do
    it { is_expected.to include_module(::BlacklightHelper) }
    it { is_expected.to include_module(CurationConcerns::MainAppHelpers) }
  end
end
