module CurationConcerns
  module Renderers
    class LinkedResourceAttributeRenderer < AttributeRenderer
      private

      def li_value(value)
        link_to(value, url_from(value)) + ' ' + tag(:span, class: 'glyphicon glyphicon-new-window')
      end

      def url_from(value)
        escaped_value = value.gsub('%', '%%')
        options.fetch(:template, escaped_value).to_s % { value: escaped_value }
      end
    end
  end
end
