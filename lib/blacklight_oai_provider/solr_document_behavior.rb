# Meant to be applied on top of SolrDocument to implement
# methods required by the ruby-oai provider
module BlacklightOaiProvider
  module SolrDocumentBehavior
    extend ActiveSupport::Concern

    def timestamp
      Time.parse(fetch('timestamp', Time.at(0).utc.to_s)).utc
    end

    # TODO: find out how to call the oai_rdf_xml method where appropriate
    def to_oai_dc
      if orcid
        export_as('oai_rdf_xml')
      else
        export_as('oai_dc_xml')
      end
    end

    def to_oai_rdf
      export_as('oai_rdf_xml')
    end
  end
end
