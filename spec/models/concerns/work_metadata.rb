require 'rails_helper'

RSpec.shared_examples_for "work_metadata" do
  describe "metadata" do
    # rubocop:disable RSpec/ExampleLength
    it "has additional metadata" do
      expect(subject).to respond_to(:unit)
      expect(subject).to respond_to(:staff_notes)
      expect(subject).to respond_to(:abstract)
      expect(subject).to respond_to(:collection_identifier)
      expect(subject).to respond_to(:sub_collection)
      expect(subject).to respond_to(:spatial)
      expect(subject).to respond_to(:alternative)
      expect(subject).to respond_to(:temporal)
      expect(subject).to respond_to(:format)
      expect(subject).to respond_to(:provenance)
      expect(subject).to respond_to(:work_type)
      expect(subject).to respond_to(:preservation_level)
      expect(subject).to respond_to(:preservation_level_rationale)
      expect(subject).to respond_to(:bibliographic_citation)
      expect(subject).to respond_to(:handle)
    end
    # rubocop:enable RSpec/ExampleLength
  end
end
