module CurationConcerns
  module Renderers
    class LinkedResourceAttributeRenderer < AttributeRenderer
      private

      def li_value(value)
        link_text = "<span class='glyphicon glyphicon-new-window'></span>&nbsp;#{ERB::Util.h(value)}"
        link_to(link_text.html_safe, url_from(value))
      end

      def url_from(value)
        options.fetch(:template, value).to_s % { value: value }
      end
    end
  end
end
