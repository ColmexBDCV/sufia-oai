class BatchUploadForm < Sufia::Forms::BatchUploadForm
  include ::CurationConcerns::MaterialsEditForm
  include ::CurationConcerns::MeasurementsEditForm

  self.terms = CurationConcerns::GenericWorkForm.terms - [:title, :resource_type]
  self.required_fields = [:unit]

  def self.reflect_on_association(association)
    model_class.reflect_on_association(association)
  end
end
