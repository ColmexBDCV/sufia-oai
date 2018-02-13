require 'rails_helper'

RSpec.describe MembershipsController, type: :controller do
  let!(:membership) { create(:membership) }
  let(:user) { create(:admin_user, email: 'foo@example.com') }

  before do
    sign_in user
  end

  describe "DELETE #destroy" do
    it "destroys the requested membership" do
      expect { delete :destroy, id: membership }
        .to change(Membership, :count).by(-1)
    end

    it "redirects to the unit" do
      delete :destroy, id: membership
      expect(response).to redirect_to edit_unit_path(membership.unit)
    end
  end
end
