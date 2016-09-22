# Start the app with EXPLAIN_PARTIALS=true to show locations of view partials
if Rails.env.development? && ENV['EXPLAIN_PARTIALS']
  module ActionView
    class PartialRenderer
      def render_with_explanation(*args)
        rendered = render_without_explanation(*args).to_s
        # Note: We haven't figured out how to get a path when @template is nil.
        start_explanation = "\n<!-- START PARTIAL #{@template.inspect} -->\n"
        end_explanation = "\n<!-- END PARTIAL #{@template.inspect} -->\n"
        # rubocop:disable Rails/OutputSafety
        start_explanation.html_safe + rendered + end_explanation.html_safe
        # rubocop:enable Rails/OutputSafety
      end

      alias_method_chain :render, :explanation
    end
  end
end
