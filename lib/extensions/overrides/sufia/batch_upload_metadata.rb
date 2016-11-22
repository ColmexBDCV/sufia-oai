module Overrides
  module Sufia
    module BatchUploadMetadata
      extend ActiveSupport::Concern
      include ::WorkMetadata
      include ::PhysicalMediaMetadata
    end
  end
end
