module Overrides
  module Hydra
    module ResolutionProperties
      extend ActiveSupport::Concern

      included do
        property :resolution_unit, predicate: ::RDF::Vocab::EXIF.resolutionUnit
        property :resolution_x, predicate: ::RDF::Vocab::EXIF.xResolution
        property :resolution_y, predicate: ::RDF::Vocab::EXIF.yResolution
      end
    end
  end
end
