require 'rails_helper'

RSpec.describe CurationConcerns::GenericWorksController, type: :controller do
  let(:user) { create(:user) }
  let(:params) { { title: ['My work'], creator: ['Creator'], keyword: ['foo'], rights: ['http://creativecommons.org/licenses/by-sa/3.0/us/'], unit: 'myunit' } }

  before do
    sign_in user
  end

  describe "modules" do
    it { is_expected.to include_module(CurationConcerns::CurationConcernController) }
    it { is_expected.to include_module(Sufia::WorksControllerBehavior) }
  end

  describe "GET #new" do
    it "assigns all the user's units to @units" do
      create(:unit)
      unit2 = create(:unit, key: 'unit2')
      unit3 = create(:unit, key: 'unit3')
      create(:membership, user: user, unit: unit2)
      create(:membership, user: user, unit: unit3)

      get :new

      expect(assigns(:units)).to eq [unit2, unit3]
    end
  end

  describe "POST #create" do
    let!(:unit) { create(:unit) }
    let!(:membership) { create(:membership, unit: unit, user: user) }

    context "when user is a member of unit" do
      it "creates a new work" do
        expect { post :create, generic_work: params }
          .to change(GenericWork, :count).by 1
      end
    end

    context "when user is not a member of unit" do
      it "refuses to create work" do
        key = 'notmyunit'
        create(:unit, key: key)

        expect { post :create, generic_work: params.merge(unit: key) }
          .not_to change(GenericWork, :count)
      end
    end
  end
end
