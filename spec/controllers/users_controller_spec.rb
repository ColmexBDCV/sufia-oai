require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  routes { Sufia::Engine.routes }
  let(:user) { create(:user) }
  let(:admin) { create(:admin_user, email: 'admin@example.com') }

  describe "modules" do
    it { is_expected.to include_module(Sufia::UsersControllerBehavior) }
  end

  describe "PUT #update" do
    let(:update_params) { { admin: '1', name: 'foo' } }

    context "as an admin" do
      before { sign_in admin }

      it "allows the admin flag to be set" do
        put :update, id: user.email, user: update_params
        user.reload
        expect(user.admin?).to be true
      end
    end

    context "as a non-admin" do
      before { sign_in user }

      it "does not allow the admin flag to be set" do
        put :update, id: user.email, user: update_params
        user.reload
        expect(user.admin?).to be false
      end
    end
  end
end
