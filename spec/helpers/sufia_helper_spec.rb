require 'rails_helper'

RSpec.describe SufiaHelper do
  describe 'modules' do
    it { is_expected.to include_module(::BlacklightHelper) }
    it { is_expected.to include_module(Sufia::BlacklightOverride) }
    it { is_expected.to include_module(Sufia::SufiaHelperBehavior) }
  end

  describe 'search_action_for_dashboard' do
    context 'from the my units controller' do
      before { allow(helper.params).to receive(:[]).with(:controller).and_return('my/units') }

      it 'returns the units dashboard path' do
        expect(helper.search_action_for_dashboard).to eq sufia.dashboard_units_path
      end
    end

    context 'from an arbitrary my dashboard controller' do
      before { allow(helper.params).to receive(:[]).with(:controller).and_return('my/works') }

      it 'returns the path for that dashboard' do
        expect(helper.search_action_for_dashboard).to eq sufia.dashboard_works_path
      end
    end
  end
end
