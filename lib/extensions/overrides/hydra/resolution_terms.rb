module Overrides
  module Hydra
    module ResolutionTerms
      extend ActiveSupport::Concern

      included do
        extend_terminology do |t|
          terms = {
            resolution_x: 'xSamplingFrequency',
            resolution_y: 'ySamplingFrequency',
            resolution_unit: 'samplingFrequencyUnit'
          }

          terms.each do |term, path|
            builder = ::OM::XML::Term::Builder.new(term.to_s, t)
            t.term_builders[:metadata].retrieve_child(:image).add_child(builder)
            builder.settings[:path] = path

            t.send(term, proxy: [:metadata, :image, term])
          end
        end
      end
    end
  end
end
