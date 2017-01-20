require 'rails_helper'

RSpec.shared_examples_for "characterization_index_terms" do
  describe "characterization metadata" do
    let(:fields) do
      [:byte_order, :capture_device, :color_map, :color_space, :compression,
       :duration, :filename, :file_size, :file_title, :gps_timestamp,
       :image_producer, :last_modified, :latitude, :longitude, :orientation,
       :original_checksum, :page_count, :profile_name, :profile_version,
       :resolution_unit, :resolution_x, :resolution_y, :sample_rate,
       :scanning_software, :well_formed]
    end

    it "has characterization metadata methods" do
      expect(subject).to respond_to(*fields)
    end
  end
end
