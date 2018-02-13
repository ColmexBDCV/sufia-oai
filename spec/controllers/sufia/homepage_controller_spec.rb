require 'rails_helper'

RSpec.describe Sufia::HomepageController, type: :controller do
  describe "modules" do
    it { is_expected.to include_module(Sufia::HomepageControllerBehavior) }
  end

  describe "GET #index" do
    let!(:unit1) { create(:unit, name: 'Test Unit', key: 'testunit') }
    let!(:unit2) { create(:unit, name: 'Another Unit', key: 'aunit') }
    let!(:unit3) { create(:unit, name: 'Hidden Unit', key: 'hiddenunit', visible: false) }

    it "assigns all visible units sorted by name as @units" do
      get :index
      expect(assigns(:units)).to eq [unit2, unit1]
    end
  end
end
