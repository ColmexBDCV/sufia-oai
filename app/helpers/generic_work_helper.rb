module GenericWorkHelper
  def generic_work_descriptions(presenter)
    attributes = [
      presenter.attribute_to_html(:resource_type, render_as: :faceted, label: 'Type' ),
      presenter.attribute_to_html(:creator, render_as: :faceted ),
      presenter.attribute_to_html(:description, label: 'Notes' ),
      presenter.attribute_to_html(:contributor, label: 'Contributors', render_as: :linked, search_field: 'contributor_tesim'),
      presenter.attribute_to_html(:subject, render_as: :faceted ),
      presenter.attribute_to_html(:publisher, render_as: :faceted ),
      presenter.attribute_to_html(:rights, render_as: :rights),
      presenter.attribute_to_html(:language, render_as: :faceted ),
      presenter.attribute_to_html(:keyword, render_as: :faceted ),
      presenter.attribute_to_html(:date_created, render_as: :linked, search_field: 'date_created_tesim', label: 'Date' ),
      presenter.attribute_to_html(:identifier),
      presenter.attribute_to_html(:archival_unit, render_as: :ead, label: 'Archival Unit'),
      presenter.attribute_to_html(:unit, render_as: :unit),
      presenter.attribute_to_html(:collection_name, render_as: :faceted, label: 'Collection'),
      presenter.attribute_to_html(:sub_collection, render_as: :faceted, label: 'Sub-Collection'),
      presenter.attribute_to_html(:bibliographic_citation, render_as: :linked, search_field: 'bibliographic_citation_tesim', label: 'Published In'),
      presenter.attribute_to_html(:collection_identifier, render_as: :linked, search_field: 'collection_identifier_tesim'),
      presenter.attribute_to_html(:based_near, render_as: :faceted, label: 'Location' ),
      presenter.attribute_to_html(:related_url, render_as: :linked_resource),
      presenter.attribute_to_html(:alternative),
      presenter.attribute_to_html(:format, render_as: :faceted),
      presenter.attribute_to_html(:source, label: 'Call number'),
      presenter.attribute_to_html(:handle, render_as: :linked_resource, template: 'http://hdl.handle.net/%{value}'),
      presenter.attribute_to_html(:preservation_level_rationale),
      presenter.attribute_to_html(:preservation_level),
      presenter.attribute_to_html(:provenance, render_as: :linked, search_field: 'provenance_tesim'),
      presenter.attribute_to_html(:spatial, render_as: :linked, search_field: 'spatial_tesim'),
      presenter.attribute_to_html(:temporal, render_as: :faceted, label: 'Time period'),
      presenter.attribute_to_html(:work_type, render_as: :faceted, label: 'Genre'),
      presenter.attribute_to_html(:material, render_as: :linked, search_field: 'material_tesim'),
      presenter.attribute_to_html(:measurement, render_as: :linked, search_field: 'measurement_tesim'),
      presenter.attribute_to_html(:embargo_release_date, render_as: :date),
      presenter.attribute_to_html(:lease_expiration_date, render_as: :date)
    ]

    attributes.insert(2, presenter.attribute_to_html(:staff_notes, search_field: 'staff_notes_tesim')) if can? :update, presenter.solr_document
    attributes.reject!(&:empty?)
  end

  def ead_resolver(ead_id)
    # ead_id format ex: SPEC.RARE.0137:ref11
    ids = ead_id.split(':')
    raise(ArgumentError, "This ead_id: #{ead_id} does not follow the expected format") if ids.count != 2
    unit_id = ids[0]
    persistent_id = ids[1]
    unit_path_prefix = get_ead_unit_path_prefix(unit_id)
    unit_path_prefix + unit_id + ".xml#" + persistent_id
  end

  # rubocop:disable Metrics/PerceivedComplexity
  def get_ead_unit_path_prefix(ead_unit)
    if ead_unit.include?("SPEC.RARE")
      "RARE/"
    elsif ead_unit.include?("SPEC.TRI")
      "TRI/"
    elsif ead_unit.include?("SPEC.PA.56")
      "ByrdPolar/"
    elsif ead_unit.include?("SPEC.RG.56")
      "ByrdPolar/"
    elsif ead_unit.include?("RG 56")
      "ByrdPolar/"
    elsif ead_unit.include?("RG")
      "UA/"
    elsif ead_unit.include?("SPEC.CGA")
      "Cartoons/"
    else
      ""
    end
  end
  # rubocop:enable Metrics/PerceivedComplexity
end
