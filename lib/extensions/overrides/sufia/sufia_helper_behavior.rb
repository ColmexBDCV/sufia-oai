module Overrides
  module Sufia
    module SufiaHelperBehavior
      extend ActiveSupport::Concern

      included do
        def link_to_profile(args)
          super
          link_to text, ENV['RAILS_RELATIVE_URL_ROOT'].to_s + Sufia::Engine.routes.url_helpers.profile_path(user)
        end
      end
    end
  end
end
