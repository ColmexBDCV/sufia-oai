require 'rails_helper'

RSpec.describe CatalogController, type: :controller do
  let(:unit) { create(:unit) }
  let!(:work) { create(:generic_work, unit: unit.key) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    context 'for a unit' do
      let(:params) { { f: { 'unit_sim' => [unit.key] } } }

      context 'as a user in the unit' do
        let(:user) { create(:user, unit: unit) }

        it 'assigns all works in unit to @response' do
          get :index, params
          expect(assigns(:response)).not_to be_empty
        end
      end

      context 'as a user not in the unit' do
        let(:user) { create(:user) }

        it 'does not assign any works to @response' do
          get :index, params
          expect(assigns(:response)).to be_empty
        end
      end
    end
  end
end
