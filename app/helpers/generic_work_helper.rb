module GenericWorkHelper
  def generic_work_descriptions(presenter)
    attributes = [
      presenter.attribute_to_html(:resource_type, render_as: :faceted, label: 'Type' ),
      presenter.attribute_to_html(:creator, render_as: :faceted ),
      presenter.attribute_to_html(:contributor, label: 'Contributors', render_as: :faceted),
      presenter.attribute_to_html(:subject, render_as: :faceted ),
      presenter.attribute_to_html(:publisher, render_as: :faceted ),
      presenter.attribute_to_html(:rights, render_as: :rights),
      presenter.attribute_to_html(:language, render_as: :faceted ),
      presenter.attribute_to_html(:keyword, render_as: :faceted ),
      presenter.attribute_to_html(:date_created, render_as: :linked, search_field: 'date_created_tesim', label: 'Date' ),
      presenter.attribute_to_html(:identifier, render_as: :linked, search_field: 'identifier_tesim'),
      presenter.attribute_to_html(:sub_collection, render_as: :linked, search_field: 'sub_collection_tesim', label: 'Sub-Collection'),
      presenter.attribute_to_html(:bibliographic_citation, render_as: :linked, search_field: 'bibliographic_citation_tesim', label: 'Published In'),
      presenter.attribute_to_html(:collection_identifier, render_as: :linked, search_field: 'collection_identifier_tesim'),
      presenter.attribute_to_html(:based_near, render_as: :faceted, label: 'Location' ),
      presenter.attribute_to_html(:related_url),
      presenter.attribute_to_html(:alternative, render_as: :linked, search_field: 'alternative_tesim', label: 'Alternative title'),
      presenter.attribute_to_html(:format, render_as: :linked, search_field: 'format_tesim'),
      presenter.attribute_to_html(:source, label: 'Call number'),
      presenter.attribute_to_html(:handle),
      render('unit', presenter: presenter),
      presenter.attribute_to_html(:preservation_level_rationale, render_as: :linked, search_field: 'preservation_level_rationale_tesim'),
      presenter.attribute_to_html(:preservation_level, render_as: :linked, search_field: 'preservation_level_tesim'),
      presenter.attribute_to_html(:provenance, render_as: :linked, search_field: 'provenance_tesim'),
      presenter.attribute_to_html(:spatial, render_as: :linked, search_field: 'spatial_tesim'),
      presenter.attribute_to_html(:temporal, render_as: :linked, search_field: 'temporal_tesim', label: 'Time period'),
      presenter.attribute_to_html(:work_type, render_as: :linked, search_field: 'work_type_tesim', label: 'Genre'),
      presenter.attribute_to_html(:material, render_as: :linked, search_field: 'material_tesim'),
      presenter.attribute_to_html(:material_type, render_as: :linked, search_field: 'material_type_tesim'),
      presenter.attribute_to_html(:measurement, render_as: :linked, search_field: 'measurement_tesim'),
      presenter.attribute_to_html(:measurement_unit, render_as: :linked, search_field: 'measurement_unit_tesim'),
      presenter.attribute_to_html(:measurement_type, render_as: :linked, search_field: 'measurement_type_tesim'),
      presenter.attribute_to_html(:embargo_release_date),
      presenter.attribute_to_html(:lease_expiration_date)
    ]

    attributes.insert(2, presenter.attribute_to_html(:staff_notes, search_field: 'staff_notes_tesim')) if can? :update, presenter.solr_document
    attributes.reject! { |a| a.empty? }
  end
end
