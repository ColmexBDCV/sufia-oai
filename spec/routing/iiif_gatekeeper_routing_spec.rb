require "rails_helper"

RSpec.describe IiifGatekeeperController, type: :routing do
  describe "routing" do
    it "routes to #show" do
      expect(get: "/gatekeeper/my/ident").to route_to("iiif_gatekeeper#show", ident: "my/ident")
    end
  end
end
