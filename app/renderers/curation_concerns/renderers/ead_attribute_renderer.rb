module CurationConcerns
  module Renderers
    class EadAttributeRenderer < FacetedAttributeRenderer
      private

      def li_value(value)
        resolver = ::FindingAidResolver.new(value)
        link_to(resolver.short_id, resolver.url) + ' ' + tag(:span, class: 'glyphicon glyphicon-new-window')
      rescue ArgumentError
        super
      end
    end
  end
end
