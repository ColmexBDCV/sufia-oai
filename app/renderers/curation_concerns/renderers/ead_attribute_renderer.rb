module CurationConcerns
  module Renderers
    class EadAttributeRenderer < FacetedAttributeRenderer
      private

      def li_value(value)
        resolver = ::FindingAidResolver.new(value)
        link_text = safe_join [tag(:span, class: 'glyphicon glyphicon-new-window'), " ", resolver.short_id]
        link_to(link_text, resolver.url)
      rescue ArgumentError
        super
      end
    end
  end
end
