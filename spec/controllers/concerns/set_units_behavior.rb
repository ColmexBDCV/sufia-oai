require 'rails_helper'

RSpec.shared_examples_for "set_units_behavior" do
  let(:model) { nil }
  let!(:unit1) { create(:unit, name: 'Test Unit', key: 'testunit') }
  let!(:unit2) { create(:unit, name: 'Another Unit', key: 'aunit') }

  describe "set_units action" do
    context "user is an admin" do
      let(:user) { create(:admin_user) }
      let(:all_units) { [unit1, unit2] }

      it "assigns all units to @units" do
        get :new
        expect(assigns(:units)).to eq all_units

        if model.present?
          get :edit, id: model.id
          expect(assigns(:units)).to eq all_units
        end
      end
    end

    context "user is in a unit" do
      let(:user) { create(:user, unit: unit1) }
      let(:user_unit) { [unit1] }

      it "assigns only that unit to @units" do
        get :new
        expect(assigns(:units)).to eq user_unit

        if model.present?
          get :edit, id: model.id
          expect(assigns(:units)).to eq user_unit
        end
      end
    end

    context "user is not in a unit" do
      let(:user) { create(:user) }

      it "does not add any units to @units" do
        get :new
        expect(assigns(:units)).to be_empty

        if model.present?
          get :edit, id: model.id
          expect(assigns(:units)).to be_empty
        end
      end
    end
  end
end
