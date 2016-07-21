module CurationConcerns
  module MaterialsEditForm
    extend ActiveSupport::Concern

    included do
      self.terms += [ :materials_attributes ]
    end
      
  end
end
