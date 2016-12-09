require 'rails_helper'

RSpec.shared_examples_for "tombstoneable" do
  let(:factory) { nil }

  describe "GET #show" do
    context "when object is deleted with tombstone" do
      let(:object) { create(factory) }
      before { object.destroy }

      it "renders the 410 Gone error page" do
        get :show, id: object.id
        expect(response.status).to eq 410
        expect(response).to render_template '410'
      end
    end

    context "when object is missing" do
      it "renders the 404 Not Found error page" do
        get :show, id: 'notanidatall'
        expect(response.status).to eq 404
        expect(response).to render_template '404'
      end
    end

    context "when object is private" do
      let(:object) { create(factory, :private) }

      it "redirects user to authenticate" do
        get :show, id: object.id
        expect(response.status).to eq 302
      end
    end

    context "when object is public" do
      let(:object) { create(factory, :public) }

      it "dislays the object" do
        get :show, id: object.id
        expect(response.status).to eq 200
        expect(response).to render_template :show
      end
    end
  end
end
