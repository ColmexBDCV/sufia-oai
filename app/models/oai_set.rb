class OaiSet < BlacklightOaiProvider::Set
  class << self
    def all
      Unit.visible
    end

    # Return a Solr filter query given a set spec
    def from_spec(spec)
      parts = spec.split(':')
      raise OAI::ArgumentException unless parts.count == 2 && parts[0] == 'unit'
      "unit_ssim:#{parts[1]}"
    end
  end
end
