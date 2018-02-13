# Load the handle server configuration
Rails.application.config.x.handle = Hashie::Mash.new(Rails.application.config_for(:handle_server))
