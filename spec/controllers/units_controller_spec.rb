require 'rails_helper'

RSpec.describe UnitsController, type: :controller do
  let!(:unit) { create(:unit) }
  let(:user) { create(:admin_user) }
  let(:new_unit) { build(:unit, name: 'Test Unit', key: 'testunit') }
  let(:invalid_unit) { build(:unit, name: 'Invalid Unit', key: nil) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "assigns all units as @units" do
      get :index
      expect(assigns(:units)).to eq [unit]
    end
  end

  describe "GET #show" do
    it "redirects to the unit catalog page" do
      get :show, id: unit
      expect(response).to redirect_to search_catalog_path(f: { 'unit_sim' => [unit.key] })
    end
  end

  describe "GET #new" do
    it "assigns a new unit as @unit" do
      get :new
      expect(assigns(:unit)).to be_a_new Unit
    end
  end

  describe "GET #edit" do
    it "assigns the requested unit as @unit" do
      get :edit, id: unit
      expect(assigns(:unit)).to eq unit
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new unit" do
        expect { post :create, unit: new_unit.attributes }
          .to change(Unit, :count).by 1
      end

      it "assigns a newly created unit as @unit" do
        post :create, unit: new_unit.attributes
        expect(assigns(:unit)).to be_a Unit
        expect(assigns(:unit)).to be_persisted
      end

      it "redirects to the created unit" do
        post :create, unit: new_unit.attributes
        expect(response).to redirect_to Unit.last
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved unit as @unit" do
        post :create, unit: invalid_unit.attributes
        expect(assigns(:unit)).to be_a_new Unit
      end

      it "re-renders the 'new' template" do
        post :create, unit: invalid_unit.attributes
        expect(response).to render_template "new"
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:update_params) { { name: 'A new name', key: 'anewkey' } }

      it "updates the requested unit" do
        put :update, id: unit, unit: update_params
        unit.reload
        expect(unit.name).to eq update_params[:name]
      end

      it "does not update the unit key" do
        put :update, id: unit, unit: update_params
        unit.reload
        expect(unit.key).to eq 'myunit'
      end

      it "assigns the requested unit as @unit" do
        put :update, id: unit, unit: update_params
        expect(assigns(:unit)).to eq unit
      end

      it "redirects to the unit" do
        put :update, id: unit, unit: update_params
        expect(response).to redirect_to unit
      end
    end

    context "with invalid params" do
      let(:update_params) { { name: nil } }

      it "assigns the unit as @unit" do
        put :update, id: unit, unit: update_params
        expect(assigns(:unit)).to eq unit
      end

      it "re-renders the 'edit' template" do
        put :update, id: unit, unit: update_params
        expect(response).to render_template "edit"
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested unit" do
      expect { delete :destroy, id: unit }
        .to change(Unit, :count).by(-1)
    end

    it "redirects to the units list" do
      delete :destroy, id: unit
      expect(response).to redirect_to units_url
    end
  end
end
