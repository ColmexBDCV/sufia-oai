require 'rails_helper'

RSpec.describe FileSet do
  let(:mime_types) { ['image/png', 'image/jpeg', 'image/jpg', 'image/jp2', 'image/bmp', 'image/gif', 'image/tiff', 'application/octet-stream'] }

  describe '.image_mime_types' do
    it 'returns the default set of mime types plus application/octet-stream' do
      expect(described_class.image_mime_types).to eq mime_types
    end
  end
end
