module ApplicationHelper
  def login_strategy
    Rails.env.production? ? :shibboleth : :developer
  end
end
