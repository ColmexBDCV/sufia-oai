require 'rails_helper'

RSpec.describe UnitsController, type: :controller do
  let(:valid_attributes) { {name: 'Test Unit', key: 'testunit'} }
  let(:invalid_attributes) { {name: 'Test Unit'} }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # unitsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all units as @units" do
      unit = Unit.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:units)).to eq([unit])
    end
  end

  describe "GET #show" do
    it "assigns the requested unit as @unit" do
      unit = Unit.create! valid_attributes
      get :show, params: {id: unit.to_param}
      expect(assigns(:unit)).to eq(unit)
    end
  end

  describe "GET #new" do
    it "assigns a new unit as @unit" do
      get :new, params: {}, session: valid_session
      expect(assigns(:unit)).to be_a_new(Unit)
    end
  end

  describe "GET #edit" do
    it "assigns the requested unit as @unit" do
      unit = Unit.create! valid_attributes
      get :edit, params: {id: unit.to_param}, session: valid_session
      expect(assigns(:unit)).to eq(unit)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new unit" do
        expect {
          post :create, params: {unit: valid_attributes}, session: valid_session
        }.to change(Unit, :count).by(1)
      end

      it "assigns a newly created unit as @unit" do
        post :create, params: {unit: valid_attributes}, session: valid_session
        expect(assigns(:unit)).to be_a(Unit)
        expect(assigns(:unit)).to be_persisted
      end

      it "redirects to the created unit" do
        post :create, params: {unit: valid_attributes}, session: valid_session
        expect(response).to redirect_to(unit.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved unit as @unit" do
        post :create, params: {unit: invalid_attributes}, session: valid_session
        expect(assigns(:unit)).to be_a_new(Unit)
      end

      it "re-renders the 'new' template" do
        post :create, params: {unit: invalid_attributes}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested unit" do
        unit = Unit.create! valid_attributes
        put :update, params: {id: unit.to_param, unit: new_attributes}, session: valid_session
        unit.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested unit as @unit" do
        unit = Unit.create! valid_attributes
        put :update, params: {id: unit.to_param, unit: valid_attributes}, session: valid_session
        expect(assigns(:unit)).to eq(unit)
      end

      it "redirects to the unit" do
        unit = Unit.create! valid_attributes
        put :update, params: {id: unit.to_param, unit: valid_attributes}, session: valid_session
        expect(response).to redirect_to(unit)
      end
    end

    context "with invalid params" do
      it "assigns the unit as @unit" do
        unit = Unit.create! valid_attributes
        put :update, params: {id: unit.to_param, unit: invalid_attributes}, session: valid_session
        expect(assigns(:unit)).to eq(unit)
      end

      it "re-renders the 'edit' template" do
        unit = Unit.create! valid_attributes
        put :update, params: {id: unit.to_param, unit: invalid_attributes}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested unit" do
      unit = Unit.create! valid_attributes
      expect {
        delete :destroy, params: {id: unit.to_param}, session: valid_session
      }.to change(unit, :count).by(-1)
    end

    it "redirects to the units list" do
      unit = Unit.create! valid_attributes
      delete :destroy, params: {id: unit.to_param}, session: valid_session
      expect(response).to redirect_to(units_url)
    end
  end
end
