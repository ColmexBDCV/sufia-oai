module Overrides
  module Oai
    module IdExtractor
      extend ActiveSupport::Concern

      included do
        private

        # Fix the OAI gem resource identifier format
        def extract_identifier(id)
          id.sub("#{provider.prefix}:dc/", '')
        end
      end
    end
  end
end
