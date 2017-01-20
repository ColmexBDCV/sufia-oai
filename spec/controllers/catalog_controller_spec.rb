require 'rails_helper'

RSpec.describe CatalogController, type: :controller do
  let(:unit) { create(:unit) }
  let!(:work) { create(:generic_work, unit: unit.key) }

  describe 'GET #index' do
    before { sign_in user }

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

  describe '#search_builder' do
    it 'returns a search builder of the local search builder class' do
      expect(subject.search_builder).to be_a CatalogSearchBuilder
    end
  end
end
