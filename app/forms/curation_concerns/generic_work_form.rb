# Generated via
#  `rails generate curation_concerns:work GenericWork`
module CurationConcerns
  class GenericWorkForm < Sufia::Forms::WorkForm
    include MaterialsEditForm
    include MeasurementsEditForm
    self.model_class = ::GenericWork
    self.terms += [:unit, :resource_type, :staff_notes, :sub_collection,
                   :spatial, :alternative, :temporal, :format, :provenance,
                   :work_type, :preservation_level, :preservation_level_rationale, :handle]
    self.required_fields += [:unit]
    def self.reflect_on_association(association)
      ::GenericWork.reflect_on_association(association)
    end
  end
end
