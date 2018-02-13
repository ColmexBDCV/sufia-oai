require 'rails_helper'

RSpec.describe 'curation_concerns/base/show.html.erb', type: :view do
  let(:ability) { double }
  let(:generic_work) { create(:public_generic_work, :without_validations) }
  let(:solr_document) { SolrDocument.new(generic_work.to_solr) }
  let(:presenter) { Sufia::WorkShowPresenter.new(solr_document, ability) }

  before do
    assign :presenter, presenter
    allow(ability).to receive(:can?).and_return(true)
    allow(view).to receive(:can?).and_return(true)
    render
  end

  it 'Removes the Relationships section' do
    expect(rendered).not_to have_content 'Relationships'
  end
end
