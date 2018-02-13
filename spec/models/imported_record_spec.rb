require 'rails_helper'

RSpec.describe ImportedRecord, type: :model do
  let(:imported_record) { create(:imported_record) }

  describe "modules" do
    it { is_expected.to include_module(FedoraObjectAssociations) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:import) }
    it { is_expected.to respond_to(:file) }
  end

  describe "#completely_destroy_file!" do
    context "with an associated work" do
      let(:work) { create(:generic_work) }
      let!(:imported_record) { create(:imported_record, file: work) }

      it "destroys the work" do
        expect { imported_record.completely_destroy_file! }.to change(GenericWork, :count).by(-1)
      end
    end

    context "without a work" do
      it "returns false" do
        expect(imported_record.completely_destroy_file!).to be false
      end
    end

    context "with a nil work id" do
      let!(:work) { create(:generic_work) }
      let!(:imported_record) { create(:imported_record, generic_work_pid: nil) }

      it "does not destroy any works" do
        expect { imported_record.completely_destroy_file! }.to change(GenericWork, :count).by(0)
      end
    end
  end
end
