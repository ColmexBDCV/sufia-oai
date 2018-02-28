module GenericWorkHelper
  def generic_work_descriptions(presenter)
    attributes = [
      presenter.attribute_to_html(:resource_type, render_as: :faceted, label: 'Tipo' ),
      presenter.attribute_to_html(:creator, render_as: :faceted, label: 'Creador' ),
      #presenter.attribute_to_html(:creator, render_as: :faceted ),
      #presenter.attribute_to_html(:orcid, label: "Creador ORCID" ),
      #presenter.attribute_to_html(:cvu, label: "Creador CVU" ),
      presenter.attribute_to_html(:description, label: 'Notas' ),
      presenter.attribute_to_html(:contributor, label: 'Contribuidores', render_as: :linked, search_field: 'contributor_tesim'),
      presenter.attribute_to_html(:subject, render_as: :faceted, label: 'Tema' ),
      presenter.attribute_to_html(:publisher, render_as: :faceted, label: 'Editorial' ),
      presenter.attribute_to_html(:audience, label: 'Audiencia', render_as: :linked, search_field: 'audience_tesim'),
      presenter.attribute_to_html(:rights_statements, label: 'Derechos'),
      presenter.attribute_to_html(:rights, label: 'Licencia de uso', render_as: :rights),
      presenter.attribute_to_html(:language, render_as: :faceted, label:'Idioma' ),
      presenter.attribute_to_html(:keyword, render_as: :faceted ),
      presenter.attribute_to_html(:date_created, render_as: :linked, search_field: 'date_created_tesim', label: 'Fecha de creación' ),
      presenter.attribute_to_html(:identifier, label: 'Identificador'),
      presenter.attribute_to_html(:archival_unit, render_as: :ead, label: 'Archival Unit'),
      presenter.attribute_to_html(:unit, render_as: :unit, label: 'Unidad'),
      #presenter.attribute_to_html(:collection_name, render_as: :faceted, label: 'Colleción'),
      presenter.attribute_to_html(:sub_collection, render_as: :faceted, label: 'Sub-Colleción'),
      presenter.attribute_to_html(:bibliographic_citation, render_as: :linked, search_field: 'bibliographic_citation_tesim', label: 'Publicado en'),
      #presenter.attribute_to_html(:collection_identifier, render_as: :linked, search_field: 'collection_identifier_tesim'),
      presenter.attribute_to_html(:based_near, render_as: :faceted, label: 'Localización' ),
      presenter.attribute_to_html(:related_url, render_as: :linked_resource),
      presenter.attribute_to_html(:alternative),
      presenter.attribute_to_html(:format, render_as: :faceted, label: "Formato"),
      presenter.attribute_to_html(:source, label: 'Call number'),
      presenter.attribute_to_html(:handle, render_as: :linked_resource, template: 'http://hdl.handle.net/%{value}'),
      presenter.attribute_to_html(:preservation_level_rationale),
      presenter.attribute_to_html(:preservation_level),
      presenter.attribute_to_html(:provenance, render_as: :linked, search_field: 'provenance_tesim'),
      presenter.attribute_to_html(:spatial, render_as: :linked, search_field: 'spatial_tesim', label: 'Place'),
      presenter.attribute_to_html(:temporal, render_as: :faceted, label: 'Time period'),
      presenter.attribute_to_html(:work_type, render_as: :faceted, label: 'Genre'),
      presenter.attribute_to_html(:material, render_as: :linked, search_field: 'material_tesim'),
      presenter.attribute_to_html(:measurement, render_as: :linked, search_field: 'measurement_tesim'),
      presenter.attribute_to_html(:embargo_release_date, render_as: :date),
      presenter.attribute_to_html(:lease_expiration_date, render_as: :date),
    ]

    # attributes.insert(2, presenter.attribute_to_html(:staff_notes, search_field: 'staff_notes_tesim')) if can? :update, presenter.solr_document
    attributes.reject!(&:empty?)
  end

end
