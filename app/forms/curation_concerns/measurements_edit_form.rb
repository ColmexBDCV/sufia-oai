module CurationConcerns
  module MeasurementsEditForm
    extend ActiveSupport::Concern
    
    included do
      self.terms += [ :measurements_attributes ]
    end
      
  end
end
