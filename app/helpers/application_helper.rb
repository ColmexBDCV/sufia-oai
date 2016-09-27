module ApplicationHelper
  def login_strategy
    Rails.env.production? ? :shibboleth : :developer
  end

  def title_for(model, property = :name)
    model.send(property).presence || 'Untitled'
  end
end
