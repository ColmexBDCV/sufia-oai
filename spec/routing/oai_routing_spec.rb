require "rails_helper"

RSpec.describe API::V1::OaiController, type: :routing do
  describe "routing" do
    it "routes to #oai" do
      expect(get: "/api/oai").to route_to(controller: 'api/v1/oai', action: 'oai', format: 'xml')
      expect(post: "/api/oai").to route_to(controller: 'api/v1/oai', action: 'oai', format: 'xml')
    end
  end
end
