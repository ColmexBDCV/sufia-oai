require 'rails_helper'

RSpec.describe MembershipsController, type: :controller do
  let!(:unit) { create(:unit) }
  let!(:membership) { create(:membership) }
  let(:another_unit) { create(:unit, name: 'Another Unit', key: 'anotherunit') }
  let(:new_membership) { build(:membership, unit: another_unit, user: membership.user) }
  let(:invalid_membership) { build(:membership, level: nil, user: membership.user) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # membershipsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "POST #create" do
    context "with valid params" do
      it "creates a new membership" do
        expect { post :create, unit_id: unit, membership: new_membership.attributes, session: valid_session }
          .to change(Membership, :count).by 1
      end

      it "assigns a newly created membership as @membership" do
        post :create, unit_id: unit, membership: new_membership.attributes, session: valid_session
        expect(assigns(:membership)).to be_a Membership
        expect(assigns(:membership)).to be_persisted
      end

      it "redirects to the unit" do
        post :create, unit_id: unit, membership: new_membership.attributes, session: valid_session
        expect(response).to redirect_to unit
      end
    end

    context "with invalid params" do
      it "redirects to the unit" do
        post :create, unit_id: unit, membership: invalid_membership.attributes, session: valid_session
        expect(response).to redirect_to unit
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:update_params) { { level: 'AnotherLevel' } }

      it "updates the requested membership" do
        put :update, unit_id: unit, id: membership, membership: update_params, session: valid_session
        membership.reload
        expect(membership.level).to eq update_params[:level]
      end

      it "redirects to the unit" do
        put :update, unit_id: unit, id: membership, membership: update_params, session: valid_session
        expect(response).to redirect_to unit
      end
    end

    context "with invalid params" do
      let(:update_params) { { level: nil } }

      it "redirects to the unit" do
        put :update, unit_id: unit, id: membership, membership: update_params, session: valid_session
        expect(response).to redirect_to unit
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested membership" do
      expect { delete :destroy, unit_id: unit, id: membership, session: valid_session }
        .to change(Membership, :count).by(-1)
    end

    it "redirects to the unit" do
      delete :destroy, unit_id: unit, id: membership, session: valid_session
      expect(response).to redirect_to unit
    end
  end
end
