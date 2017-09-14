require 'rails_helper'

RSpec.describe Sufia::WorkShowPresenter do
  subject { described_class.new(document, ability) }

  let(:ability) { double }
  let(:work) { build(:work) }
  let(:document) { SolrDocument.new(work.to_solr) }

  let(:presented_terms) do
    %i[
      abstract based_near related_url depositor identifier archival_unit resource_type
      keyword itemtype alternative format handle unit collection_name
      sub_collection preservation_level preservation_level_rationale
      provenance spatial staff_notes temporal work_type material
      material_type measurement measurement_unit measurement_type
      bibliographic_citation collection_identifier
      audience rights_statements orcid
    ]
  end
  describe "delegations" do
    it { is_expected.to delegate_method(:abstract).to(:solr_document) }
    it { is_expected.to delegate_method(:based_near).to(:solr_document) }
    it { is_expected.to delegate_method(:related_url).to(:solr_document) }
    it { is_expected.to delegate_method(:depositor).to(:solr_document) }
    it { is_expected.to delegate_method(:identifier).to(:solr_document) }
    it { is_expected.to delegate_method(:archival_unit).to(:solr_document) }
    it { is_expected.to delegate_method(:resource_type).to(:solr_document) }
    it { is_expected.to delegate_method(:keyword).to(:solr_document) }
    it { is_expected.to delegate_method(:itemtype).to(:solr_document) }
    it { is_expected.to delegate_method(:alternative).to(:solr_document) }
    it { is_expected.to delegate_method(:format).to(:solr_document) }
    it { is_expected.to delegate_method(:handle).to(:solr_document) }
    it { is_expected.to delegate_method(:unit).to(:solr_document) }
    it { is_expected.to delegate_method(:collection_name).to(:solr_document) }
    it { is_expected.to delegate_method(:sub_collection).to(:solr_document) }
    it { is_expected.to delegate_method(:preservation_level).to(:solr_document) }
    it { is_expected.to delegate_method(:preservation_level_rationale).to(:solr_document) }
    it { is_expected.to delegate_method(:provenance).to(:solr_document) }
    it { is_expected.to delegate_method(:spatial).to(:solr_document) }
    it { is_expected.to delegate_method(:staff_notes).to(:solr_document) }
    it { is_expected.to delegate_method(:temporal).to(:solr_document) }
    it { is_expected.to delegate_method(:work_type).to(:solr_document) }
    it { is_expected.to delegate_method(:material).to(:solr_document) }
    it { is_expected.to delegate_method(:material_type).to(:solr_document) }
    it { is_expected.to delegate_method(:measurement).to(:solr_document) }
    it { is_expected.to delegate_method(:measurement_unit).to(:solr_document) }
    it { is_expected.to delegate_method(:measurement_type).to(:solr_document) }
    it { is_expected.to delegate_method(:bibliographic_citation).to(:solr_document) }
    it { is_expected.to delegate_method(:collection_identifier).to(:solr_document) }
    it { is_expected.to delegate_method(:audience).to(:solr_document) }
    it { is_expected.to delegate_method(:rights_statements).to(:solr_document) }
    it { is_expected.to delegate_method(:orcid).to(:solr_document) }
  end
end
