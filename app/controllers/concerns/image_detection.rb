module ImageDetection
  extend ActiveSupport::Concern

  private

  def image?(obj)
    if obj.respond_to?(:mime_type)
      # Add MIME type detection to file if necessary
      unless obj.respond_to? :image?
        obj.extend(Hydra::Works::MimeTypes)
        obj.class.extend(Hydra::Works::MimeTypes::ClassMethods)
      end
      obj.image?
    else
      false
    end
  end
end
