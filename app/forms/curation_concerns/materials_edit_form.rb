module CurationConcerns
  module MaterialsEditForm
    extend ActiveSupport::Concern

    module ClassMethods
      def build_permitted_params
        permitted = super
        permitted << { materials_attributes: [:material_type, :material, :id, :_destroy] }
      end
    end

    included do
      delegate :materials, :materials_attributes=, to: :model
      terms << :materials_attributes
    end
  end
end
