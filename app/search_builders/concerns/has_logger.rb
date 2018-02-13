module HasLogger
  extend ActiveSupport::Concern

  included do
    def logger
      Rails.logger
    end
  end
end
