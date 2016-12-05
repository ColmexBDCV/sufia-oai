module SufiaHelper
  include ::BlacklightHelper
  include Sufia::BlacklightOverride
  include Sufia::SufiaHelperBehavior

  # *Sometimes* a Blacklight index field helper_method
  # @param [String,User,Hash{Symbol=>Array}] args if a hash, the user_key must be under :value
  # @return [ActiveSupport::SafeBuffer] the html_safe link
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
    link_to text, sufia.profile_path(user)
  end
end
