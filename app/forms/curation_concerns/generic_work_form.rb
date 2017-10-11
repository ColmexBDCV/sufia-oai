module CurationConcerns
  class GenericWorkForm < Sufia::Forms::WorkForm
    include MaterialsEditForm
    include MeasurementsEditForm

    self.model_class = ::GenericWork

    self.terms = [:resource_type, :title, :unit, :collection_name, :creator, :orcid, :cvu, :contributor, :audience, :abstract, :description, :bibliographic_citation, :keyword,
                  :rights_statements, :rights, :provenance, :publisher, :date_created, :subject,
                  :language, :identifier, :archival_unit, :based_near, :related_url, :work_type,
                  :spatial, :alternative, :temporal, :format, :staff_notes,
                  :source, :sub_collection, :preservation_level_rationale,
                  :preservation_level, :collection_identifier,
                  :measurements_attributes, :materials_attributes,
                  :representative_id, :thumbnail_id, :files,
                  :visibility_during_embargo, :embargo_release_date,
                  :visibility_after_embargo, :visibility_during_lease,
                  :lease_expiration_date, :visibility_after_lease, :visibility,
                  :ordered_member_ids, :in_works_ids, :collection_ids]

    self.required_fields = [:resource_type, :title, :unit]

    def self.reflect_on_association(association)
      ::GenericWork.reflect_on_association(association)
    end
  end
end
