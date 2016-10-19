require 'rails_helper'
require 'models/concerns/work_metadata'
require 'models/concerns/physical_media_metadata'

RSpec.describe GenericWork, type: :model do
  let(:unit) { create(:unit, key: 'myunit') }
  let(:work) { create(:generic_work, unit: unit.key) }

  describe "modules" do
    it { is_expected.to include_module(CurationConcerns::WorkBehavior) }
    it { is_expected.to include_module(CurationConcerns::BasicMetadata) }
    it { is_expected.to include_module(Sufia::WorkBehavior) }
    it { is_expected.to include_module(WorkMetadata) }
    it { is_expected.to include_module(PhysicalMediaMetadata) }
  end

  it_behaves_like "work_metadata"
  it_behaves_like "physical_media_metadata"

  describe ".human_readable_type" do
    it "returns Work" do
      expect(described_class.human_readable_type).to eq 'Work'
    end
  end

  describe "#responsible_unit" do
    context "the unit exists" do
      it "returns the unit model" do
        expect(work.responsible_unit).to eq unit
      end
    end

    context "the unit does not exist" do
      it "returns nil" do
        work.responsible_unit.destroy
        expect(work.responsible_unit).to be_nil
      end
    end
  end

  describe "#set_admin_poilcy" do
    context "for a new work" do
      it "assigns the unit admin policy to the work" do
        expect(work.admin_policy).to eq unit.admin_policy
      end
    end

    context "for an existing work" do
      let(:unit2) { create(:unit, name: 'Unit 2', key: 'unit2') }
      let!(:work) { create(:generic_work, unit: unit.key) }

      it "assigns the unit admin policy to the work" do
        work.unit = unit2.key
        work.save

        expect(work.admin_policy).to eq unit2.admin_policy
      end
    end
  end

  describe "#to_solr" do
    let(:measurement) { create(:measurement) }
    let(:material) { create(:material) }
    let(:work) { create(:generic_work, measurements: [measurement], materials: [material]) }

    it "contains measurements and materials" do
      expect(work.to_solr).to include('measurement_tesim', 'material_tesim')
    end
  end
end
