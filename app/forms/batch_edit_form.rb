class BatchEditForm < Sufia::Forms::BatchEditForm
  # TODO: This does not handle non-array metadata
  self.terms = [:resource_type, :creator, :contributor,
                :abstract, :description, :bibliographic_citation, :keyword,
                :rights, :provenance, :publisher, :date_created, :subject,
                :language, :identifier, :based_near, :related_url, :work_type,
                :spatial, :alternative, :temporal, :format, :staff_notes,
                :source, :collection_name, :sub_collection]

  def self.build_permitted_params
    super + [:visibility]
  end
end
