require "rails_helper"

RSpec.describe OaiController, type: :routing do
  describe "routing" do
    it "routes to #oai" do
      expect(get: "/catalog/oai").to route_to("oai#oai")
      expect(post: "/catalog/oai").to route_to("oai#oai")
    end
  end
end
