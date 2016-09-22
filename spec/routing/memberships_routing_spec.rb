require "rails_helper"

RSpec.describe MembershipsController, type: :routing do
  describe "routing" do
    it "routes to #destroy" do
      expect(delete: "/memberships/1").to route_to("memberships#destroy", id: "1")
    end

    it "does not route to #new, #edit, #index, #show, #create or #update" do
      expect(get: "/memberships/new").not_to be_routable
      expect(get: "/memberships/1/edit").not_to be_routable
      expect(get: "/memberships").not_to be_routable
      expect(get: "/memberships/1").not_to be_routable
      expect(post: "/memberships").not_to be_routable
      expect(patch: "/memberships/1").not_to be_routable
      expect(put: "/memberships/1").not_to be_routable
    end
  end
end
