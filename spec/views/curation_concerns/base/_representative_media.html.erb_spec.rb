require 'rails_helper'

RSpec.describe 'curation_concerns/base/_representative_media.html.erb', type: :view do
  let(:ability) { double }

  before do
    view.extend Openseadragon::OpenseadragonHelper
    allow(view).to receive(:iiif_url_for).and_return('http://example.com/wd/37/5w/29/wd375w296/files/ed0115bd-cff7-465d-8e62-659d08cb4ccc-version1')
  end

  context 'for a work with a representative image file' do
    let(:generic_work) { create(:generic_work, :with_image, :without_validations) }
    let(:solr_document) { SolrDocument.new(generic_work.to_solr) }
    let(:presenter) { Sufia::WorkShowPresenter.new(solr_document, ability) }

    context 'as a user without update permissions' do
      before do
        allow(view).to receive(:can?).with(:update, SolrDocument).and_return(false)
        render 'curation_concerns/base/representative_media', presenter: presenter
      end

      it 'does not show the full download link' do
        expect(rendered).not_to have_link 'Download the full-sized image'
      end
    end

    context 'as a user with update ablities' do
      before do
        allow(view).to receive(:can?).with(:update, SolrDocument).and_return(true)
        render 'curation_concerns/base/representative_media', presenter: presenter
      end

      it 'shows the full download link' do
        expect(rendered).to have_link 'Download the full-sized image'
      end
    end
  end
end
