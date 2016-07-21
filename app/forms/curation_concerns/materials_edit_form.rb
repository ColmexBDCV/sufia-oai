module CurationConcerns
  module MaterialsEditForm
    extend ActiveSupport::Concern

    module ClassMethods
      def build_permitted_params
        permitted = super
        permitted << { :materials_attributes => [:material_type, :material, :id, :_destroy] }
      end
    end

    included do
      self.terms += [ :materials_attributes ]
    end

    def materials_attributes= attributes
      model.materials_attributes= attributes
    end

    def materials
      model.materials
    end

  end
end
