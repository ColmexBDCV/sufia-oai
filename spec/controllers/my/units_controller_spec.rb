require 'rails_helper'

RSpec.describe My::UnitsController, type: :controller do
  routes { Sufia::Engine.routes }

  let(:unit) { create(:unit) }
  let(:user) { create(:user, unit: unit) }

  before { sign_in user }

  describe "GET #index" do
    it "renders a successful response" do
      get :index
      expect(response).to be_successful
      expect(response).to render_template :index
    end

    it "assigns 'units' as the @selected_tab" do
      get :index
      expect(assigns(:selected_tab)).to eq 'units'
    end

    context "with multiple pages of works" do
      before { 3.times { create(:generic_work, unit: unit.key) } }

      it "paginates results" do
        get :index, per_page: 2
        expect(assigns[:document_list].length).to eq 2
        get :index, per_page: 2, page: 2
        expect(assigns[:document_list].length).to be >= 1
      end
    end

    context 'with different record types from multiple units' do
      let(:second_unit) { create(:unit, key: 'secondunit') }
      let(:other_unit) { create(:unit, key: 'otherunit') }
      let(:someone_else) { create(:user, email: 'person@example.com', unit: other_unit) }

      let!(:second_membership) { create(:membership, unit: second_unit, user: user) }

      let!(:collection) { create(:collection, :public, user: user) }
      let!(:work) { create(:work, unit: unit.key) }
      let!(:second_work) { create(:work, unit: second_unit.key) }
      let!(:other_work) { create(:work, unit: other_unit.key, user: someone_else) }
      let!(:my_file) { create(:file_set, user: user) }
      let!(:wrong_type) { ActiveFedora::Base.create! }

      let(:doc_ids) { assigns[:document_list].map(&:id) }

      it 'shows only the works in user units' do
        get :index
        expect(doc_ids).to contain_exactly(work.id, second_work.id)
      end
    end
  end

  describe "#search_builder_class" do
    it 'returns the unit search builder class' do
      expect(subject.search_builder_class).to be ::MyUnitsSearchBuilder
    end
  end
end
