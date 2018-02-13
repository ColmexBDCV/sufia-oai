require 'rails_helper'
require 'forms/curation_concerns/materials_edit_form'
require 'forms/curation_concerns/measurements_edit_form'

RSpec.describe CurationConcerns::GenericWorkForm do
  subject { described_class.new(work, ability) }
  let(:work) { build(:generic_work) }
  let(:ability) { double }
  let(:required_fields) { [:resource_type, :title, :unit] }
  let(:term_list) do
    [:resource_type, :title, :unit, :collection_name, :creator, :contributor, :audience,
     :abstract, :description, :bibliographic_citation, :keyword, :rights_statements,
     :rights, :provenance, :publisher, :date_created, :subject,
     :language, :identifier, :archival_unit, :based_near, :related_url,
     :work_type, :spatial, :alternative, :temporal, :format, :staff_notes,
     :source, :sub_collection, :preservation_level_rationale,
     :preservation_level, :collection_identifier,
     :measurements_attributes, :materials_attributes,
     :representative_id, :thumbnail_id, :files,
     :visibility_during_embargo, :embargo_release_date,
     :visibility_after_embargo, :visibility_during_lease,
     :lease_expiration_date, :visibility_after_lease, :visibility,
     :ordered_member_ids, :in_works_ids, :collection_ids, :orcid, :cvu]
  end

  describe "modules" do
    it { is_expected.to include_module(CurationConcerns::MaterialsEditForm) }
    it { is_expected.to include_module(CurationConcerns::MeasurementsEditForm) }
  end

  it_behaves_like "materials_edit_form"
  it_behaves_like "measurements_edit_form"

  describe '.reflect_on_association' do
    let(:association) { :measurements }

    it 'delegates association reflection to GenericWork' do
      expect(described_class.reflect_on_association(association)).to be_instance_of ActiveFedora::Reflection::HasManyReflection
    end
  end

  describe '.required_fields' do
    it 'returns the required fields for a generic work form' do
      expect(described_class.required_fields).to eq required_fields
    end
  end

  describe '.terms' do
    it 'returns an array of all form fields in order' do
      expect(described_class.terms).to eq term_list
    end
  end
end
