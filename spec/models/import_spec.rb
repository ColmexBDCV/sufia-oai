require 'rails_helper'

RSpec.describe Import, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:import_field_mappings).dependent(:destroy) }
    it { is_expected.to have_many(:imported_records).dependent(:destroy) }
    it { is_expected.to belong_to(:unit) }
    it { is_expected.to accept_nested_attributes_for(:import_field_mappings) }
  end

  describe "validations" do
    let(:allowed_csv_types) { ['text/csv', 'application/vnd.ms-excel', 'application/octet-stream'] }
    let(:prohibited_csv_types) { ['text/plain', 'text/xml'] }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:rights) }
    it { is_expected.to validate_presence_of(:preservation_level) }
    it { is_expected.to validate_presence_of(:unit_id) }
    it { is_expected.to validate_presence_of(:import_type) }
    it { is_expected.to validate_presence_of(:server_import_location_name) }
    it { is_expected.to validate_attachment_presence(:csv) }
    it { is_expected.to validate_attachment_content_type(:csv).allowing(allowed_csv_types).rejecting(prohibited_csv_types) }
  end

  describe 'attachements' do
    it { is_expected.to have_attached_file(:csv) }
  end
end
