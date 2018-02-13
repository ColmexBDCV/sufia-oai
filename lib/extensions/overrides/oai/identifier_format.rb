module Overrides
  module Oai
    module IdentifierFormat
      extend ActiveSupport::Concern

      included do
        private

        # Fix the OAI gem resource identifier format
        def identifier_for(record)
          "#{provider.prefix}:dc/#{record.id}"
        end
      end
    end
  end
end
