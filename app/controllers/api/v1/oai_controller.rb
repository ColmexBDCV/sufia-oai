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
              record_prefix: 'oai:repositorio2.colmex.mx',
              sample_id: 'dc/g733fx36w',
              admin_email: Sufia.config.contact_email
            },
            document: {
              limit: 3000,
              timestamp_field: 'system_modified_dtsi',
              #set_class: '::OaiSet'
              set_fields: 'sub_collection_tesim'
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
