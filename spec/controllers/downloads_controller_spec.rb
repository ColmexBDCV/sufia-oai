require 'rails_helper'

RSpec.describe DownloadsController, type: :controller do
  let(:unit) { create(:unit) }
  let(:user) { create(:user) }
  let(:generic_work) { create(:generic_work, :with_image, :without_validations, unit: unit.key, unit_model: unit, user: user) }
  let!(:membership) { create(:membership, unit: unit, user: user) }

  describe "GET #show" do
    context "as a user in the work unit" do
      before do
        sign_in user
      end

      it "allows original file download" do
        skip "Need to make original download work"
        # get :show, id: generic_work.file_sets.first.id
        # expect(response.status).to eq(200)
      end
    end

    context "as an anonymous user" do
      it "does not allow the original file to be downloaded" do
        get :show, id: generic_work.file_sets.first
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
