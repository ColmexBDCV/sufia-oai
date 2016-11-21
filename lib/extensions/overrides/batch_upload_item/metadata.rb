module Overrides
  module BatchUploadItem
    module Metadata
      extend ActiveSupport::Concern
      include ::WorkMetadata
      include ::PhysicalMediaMetadata
    end
  end
end
