# Generated via
#  `rails generate curation_concerns:work GenericWork`
module CurationConcerns
  class GenericWorkForm < Sufia::Forms::WorkForm
    self.model_class = ::GenericWork
    self.terms += [:resource_type, :staff_notes, :spatial, :alternative, :temporal, :format, :provenance, :work_type, :preservation_level, :preservation_level_rationale, :handle]

  end
end
