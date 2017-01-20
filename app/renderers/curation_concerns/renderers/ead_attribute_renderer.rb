module CurationConcerns
  module Renderers
    class EadAttributeRenderer < LinkedAttributeRenderer
      include ::GenericWorkHelper

      private

      def li_value(value)
        link_text = "<span class='glyphicon glyphicon-new-window'></span>&nbsp;#{ERB::Util.h(value)}"
        # rubocop:disable Rails/OutputSafety
        link_to(link_text.html_safe, url_from(value))
        # rubocop:enable Rails/OutputSafety
      rescue ArgumentError
        value
      end

      def url_from(value)
        "https://library.osu.edu/finding-aids/ead/#{ead_resolver(value)}"
      end
    end
  end
end
