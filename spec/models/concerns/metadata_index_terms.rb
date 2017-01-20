require 'rails_helper'

RSpec.shared_examples_for "metadata_index_terms" do
  describe "metadata" do
    let(:fields) do
      [:unit, :alternative, :format, :bibliographic_citation, :handle,
       :preservation_level, :preservation_level_rationale, :provenance,
       :spatial, :staff_notes, :abstract, :temporal, :work_type, :material,
       :material_type, :measurement, :measurement_unit, :measurement_type,
       :collection_name, :sub_collection, :collection_identifier,
       :archival_unit]
    end

    it "has indexed metadata methods" do
      expect(subject).to respond_to(*fields)
    end
  end
end
