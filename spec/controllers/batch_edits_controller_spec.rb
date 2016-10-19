require 'rails_helper'

RSpec.describe BatchEditsController, type: :controller do
  describe "modules" do
    it { is_expected.to include_module(Hydra::BatchEditBehavior) }
    it { is_expected.to include_module(FileSetHelper) }
    it { is_expected.to include_module(Sufia::BatchEditsControllerBehavior) }
  end

  describe '#form_class' do
    it 'returns our custom form class' do
      expect(subject.form_class).to be ::Sufia::BatchEditForm
    end
  end
end
