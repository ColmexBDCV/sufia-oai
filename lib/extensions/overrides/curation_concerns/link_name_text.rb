module Overrides
  module CurationConcerns
    module LinkNameText
      extend ActiveSupport::Concern
      included do
        def link_name
          current_ability.can?(:read, id) ? title&.first || label : 'File'
        end
      end
    end
  end
end
