require 'rails_helper'

RSpec.describe DownloadsController, type: :controller do
  let(:unit) { create(:unit) }
  let(:user) { create(:user, unit: unit) }

  describe "GET #show" do
    context "for an image file" do
      let(:work) { create(:generic_work, :public, :with_image, :without_validations, unit: unit.key, user: user) }

      context "as a user in the work unit" do
        before do
          sign_in user
        end

        it "allows original file download" do
          get :show, id: work.file_sets.first.id
          expect(response.status).to eq(200)
        end
      end

      context "as an anonymous user" do
        it "does not allow the original file to be downloaded" do
          get :show, id: work.file_sets.first
          expect(response).to redirect_to user_developer_omniauth_authorize_path
        end
      end
    end

    context "for a non-image file" do
      let(:work) { create(:generic_work, :public, :with_pdf, :without_validations, unit: unit.key, user: user) }

      context "as an anonymous user" do
        it "allows the original file to be downloaded" do
          get :show, id: work.file_sets.first
          expect(response.status).to eq(200)
        end
      end
    end
  end
end
