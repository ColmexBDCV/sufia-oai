require 'rails_helper'

RSpec.shared_examples_for "work_metadata" do
  describe "metadata" do
    let(:fields) do
      [:unit, :staff_notes, :abstract, :collection_identifier, :sub_collection,
       :spatial, :alternative, :temporal, :format, :provenance, :work_type,
       :preservation_level, :preservation_level_rationale,
       :bibliographic_citation, :handle, :archival_unit, :orcid, :cvu]
    end

    it "has additional metadata" do
      expect(subject).to respond_to(*fields)
    end
  end
end
