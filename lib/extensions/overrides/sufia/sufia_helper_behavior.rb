module Overrides
  module Sufia
    module SufiaHelperBehavior
      extend ActiveSupport::Concern

      included do
        def link_to_profile(args)
          user_or_key = args.is_a?(Hash) ? args[:value].first : args
          user = case user_or_key
                 when User
                   user_or_key
                 when String
                   ::User.find_by_user_key(user_or_key)
                 end
          return user_or_key if user.nil?
          text = user.respond_to?(:name) ? user.name : user_or_key
          link_to text, ENV['RAILS_RELATIVE_URL_ROOT'].to_s + sufia.routes.url_helpers.profile_path(user)
        end
      end
    end
  end
end
