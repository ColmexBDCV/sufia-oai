require 'rails_helper'

RSpec.describe 'curation_concerns/base/_representative_media.html.erb', type: :view do
  let(:ability) { double }

  before do
    allow(view).to receive(:thumbnail_url).and_return('image.jpg')
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
