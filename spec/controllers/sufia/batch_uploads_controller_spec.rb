require 'rails_helper'
require 'controllers/concerns/set_units_behavior'

RSpec.describe Sufia::BatchUploadsController, type: :controller do
  routes { Sufia::Engine.routes }

  describe "modules" do
    it { is_expected.to include_module(Sufia::BatchUploadsControllerBehavior) }
    it { is_expected.to include_module(::SetUnitsBehavior) }
  end

  describe "GET #new" do
    let(:user) { create(:admin_user) }
    before { sign_in user }

    it "disables turbolink caching" do
      get :new
      expect(assigns(:disable_turbolinks)).to be true
    end
  end

  it_behaves_like "set_units_behavior" do
    before { sign_in user }
  end

  describe '.form_class' do
    it 'returns our custom form class' do
      expect(described_class.form_class).to be ::Sufia::BatchUploadForm
    end
  end
end
