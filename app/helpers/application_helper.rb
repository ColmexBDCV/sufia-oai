module ApplicationHelper
  def login_strategy
    Rails.env.production? ? :shibboleth : :developer
  end

  def title_for(model, property = :name)
    model.send(property).presence || 'Untitled'
  end

  def relative_root_path
    ENV["RAILS_RELATIVE_URL_ROOT"] || "/"
  end

  def permissions_object_for(obj)
    obj.respond_to?(:solr_document) ? obj.solr_document : obj
  end

  def url_for(options = nil)
    super
  rescue ActionController::UrlGenerationError => exception
    begin
      sufia.url_for(options)
    rescue ActionController::UrlGenerationError
      raise exception
    end
  end
end
