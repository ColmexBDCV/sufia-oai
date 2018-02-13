require 'rails_helper'

RSpec.describe CurationConcerns::PermissionBadge do
  let(:generic_work) { build(:public_generic_work, :without_validations) }
  let(:document) { SolrDocument.new(generic_work.to_solr) }
  let(:badge) { described_class.new(document) }

  describe "render" do
    it 'labels public projects as Public' do
      expect(badge.render).to include('Public')
    end
  end
end
