module API
  module V1
    class OaiController < CatalogController
      include API::ControllerBehavior

      def initialize(*arps)
        self.class.configure_blacklight do |config|
          # Add OAI-PMH support
          config.oai = {
            provider: {
              repository_name: 'Repositorio Institucional de El Colegio de México - Biblioteca Daniel Cosío Villegas',
              repository_url: proc { api_oai_provider_url },
              #record_prefix: 'oai:library.osu.edu',
              record_prefix: 'oai:www.localhost',
              #record_prefix: 'oai:174.138.73.166:3000',
              sample_id: 'dc/g733fx36w',
              admin_email: Sufia.config.contact_email
            },
            document: {
              limit: 25,
              timestamp_field: 'system_modified_dtsi',
              set_class: '::OaiSet'
            }
          }
        end

        super
      end

      def search_builder_class
        OaiSearchBuilder
      end
    end
  end
end
