require 'rails_helper'

RSpec.describe Sufia::BatchUploadsController, type: :controller do
  describe "modules" do
    it { is_expected.to include_module(Sufia::BatchUploadsControllerBehavior) }
    it { is_expected.to include_module(::SetUnitsBehavior) }
  end

  describe '.form_class' do
    it 'returns our custom form class' do
      expect(described_class.form_class).to be ::Sufia::BatchUploadForm
    end
  end
end
