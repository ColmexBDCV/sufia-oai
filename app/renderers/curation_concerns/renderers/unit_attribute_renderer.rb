module CurationConcerns
  module Renderers
    class UnitAttributeRenderer < LinkedAttributeRenderer
      include ::UnitsHelper

      private

      def li_value(value)
        name = unit_name_from_key(value) || value
        link_to(ERB::Util.h(name), search_path(value))
      end

      def search_field
        'unit_tesim'
      end
    end
  end
end
