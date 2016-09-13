require 'rails_helper'

RSpec.describe 'curation_concerns/base/show.html.erb' do
  let(:solr_document) { SolrDocument.new(id: '999', date_modified_dtsi: '2011-04-01') }
  let(:ability) { double }
  let(:presenter) { Sufia::WorkShowPresenter.new(solr_document, ability) }

  before do
    stub_template 'curation_concerns/base/_metadata.html.erb' => ''
    stub_template 'curation_concerns/base/_relationships.html.erb' => ''
    stub_template 'curation_concerns/base/_show_actions.html.erb' => ''
    stub_template 'curation_concerns/base/_social_media.html.erb' => ''
    stub_template 'curation_concerns/base/_citations.html.erb' => ''
    stub_template 'curation_concerns/base/_items.html.erb' => ''
    assign(:presenter, presenter)
  end

  context 'as an anonymous user' do
    before do
      allow(view).to receive(:can?).with(:update, SolrDocument).and_return(false)
      render
    end

    it 'does not show the full download link' do
      expect(rendered).not_to have_link 'Download the full-sized image'
    end
  end

  context 'as a user with update ablities' do
    before do
      allow(view).to receive(:can?).and_return(true)
      render
    end

    it 'shows the full download link' do
      expect(rendered).to have_content 'Download the full-sized image'
    end
  end
end
