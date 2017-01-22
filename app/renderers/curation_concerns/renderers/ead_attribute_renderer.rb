module CurationConcerns
  module Renderers
    class EadAttributeRenderer < LinkedAttributeRenderer
      private

      def li_value(value)
        resolver = ::FindingAidResolver.new(value)
        link_text = "<span class='glyphicon glyphicon-new-window'></span>&nbsp;#{ERB::Util.h(value)}"
        # rubocop:disable Rails/OutputSafety
        link_to(link_text.html_safe, resolver.url)
        # rubocop:enable Rails/OutputSafety
      rescue ArgumentError
        value
      end
    end
  end
end
