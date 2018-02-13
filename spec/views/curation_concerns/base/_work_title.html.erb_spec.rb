require 'rails_helper'

RSpec.describe 'curation_concerns/base/_work_title.html.erb', type: :view do
  let(:ability) { double }
  let(:generic_work) { create(:public_generic_work, :without_validations) }
  let(:solr_document) { SolrDocument.new(generic_work.to_solr) }
  let(:presenter) { Sufia::WorkShowPresenter.new(solr_document, ability) }

  before do
    render 'curation_concerns/base/work_title', presenter: presenter
  end

  it 'labels public projects as Public' do
    expect(rendered).to have_content 'Public'
  end
end
