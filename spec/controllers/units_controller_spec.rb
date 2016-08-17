require 'rails_helper'

RSpec.describe UnitsController, type: :controller do
  let!(:unit) { create(:unit) }
  let(:new_unit) { build(:unit, name: 'Test Unit', key: 'testunit') }
  let(:invalid_unit) { build(:unit, name: 'Invalid Unit', key: nil) }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # unitsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all units as @units" do
      get :index, session: valid_session
      expect(assigns(:units)).to eq [unit]
    end
  end

  describe "GET #show" do
    it "assigns the requested unit as @unit" do
      get :show, id: unit
      expect(assigns(:unit)).to eq unit
    end
  end

  describe "GET #new" do
    it "assigns a new unit as @unit" do
      get :new, session: valid_session
      expect(assigns(:unit)).to be_a_new Unit
    end
  end

  describe "GET #edit" do
    it "assigns the requested unit as @unit" do
      get :edit, id: unit, session: valid_session
      expect(assigns(:unit)).to eq unit
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new unit" do
        expect { post :create, unit: new_unit.attributes, session: valid_session }
          .to change(Unit, :count).by 1
      end

      it "assigns a newly created unit as @unit" do
        post :create, unit: new_unit.attributes, session: valid_session
        expect(assigns(:unit)).to be_a Unit
        expect(assigns(:unit)).to be_persisted
      end

      it "redirects to the created unit" do
        post :create, unit: new_unit.attributes, session: valid_session
        expect(response).to redirect_to Unit.last
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved unit as @unit" do
        post :create, unit: invalid_unit.attributes, session: valid_session
        expect(assigns(:unit)).to be_a_new Unit
      end

      it "re-renders the 'new' template" do
        post :create, unit: invalid_unit.attributes, session: valid_session
        expect(response).to render_template "new"
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:update_params) { { name: 'A new name', key: 'anewkey' } }

      it "updates the requested unit" do
        put :update, id: unit, unit: update_params, session: valid_session
        unit.reload
        expect(unit.name).to eq update_params[:name]
      end

      it "does not update the unit key" do
        put :update, id: unit, unit: update_params, session: valid_session
        unit.reload
        expect(unit.key).to eq 'myunit'
      end

      it "assigns the requested unit as @unit" do
        put :update, id: unit, unit: update_params, session: valid_session
        expect(assigns(:unit)).to eq unit
      end

      it "redirects to the unit" do
        put :update, id: unit, unit: update_params, session: valid_session
        expect(response).to redirect_to unit
      end
    end

    context "with invalid params" do
      let(:update_params) { { name: nil } }

      it "assigns the unit as @unit" do
        put :update, id: unit, unit: update_params, session: valid_session
        expect(assigns(:unit)).to eq unit
      end

      it "re-renders the 'edit' template" do
        put :update, id: unit, unit: update_params, session: valid_session
        expect(response).to render_template "edit"
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested unit" do
      expect { delete :destroy, id: unit, session: valid_session }
        .to change(Unit, :count).by(-1)
    end

    it "redirects to the units list" do
      delete :destroy, id: unit, session: valid_session
      expect(response).to redirect_to units_url
    end
  end
end
