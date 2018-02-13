require "rails_helper"

RSpec.describe 'Sufia overrides', type: :routing do
  describe "routing" do
    it "does not route to about, contact, or help pages" do
      expect(get: "/about").to route_to("application#not_found")
      expect(get: "/contact").to route_to("application#not_found")
      expect(get: "/help").to route_to("application#not_found")
    end
  end
end
