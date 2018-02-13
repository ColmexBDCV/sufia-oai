require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe "modules" do
    it { is_expected.to include_module(Blacklight::Controller) }
    it { is_expected.to include_module(Hydra::Controller::ControllerBehavior) }
    it { is_expected.to include_module(CurationConcerns::ApplicationControllerBehavior) }
    it { is_expected.to include_module(Sufia::Controller) }
    it { is_expected.to include_module(ApplicationHelper) }
    it { is_expected.to include_module(CurationConcerns::ThemedLayoutController) }
  end

  describe '#not_found' do
    it 'raises a routing exception' do
      expect {subject.not_found}.to raise_exception(ActionController::RoutingError)
    end
  end
end
