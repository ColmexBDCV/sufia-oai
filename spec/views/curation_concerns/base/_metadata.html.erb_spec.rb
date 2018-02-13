require 'rails_helper'

RSpec.describe 'curation_concerns/base/_metadata.html.erb', type: :view do
  let(:ability) { double }
  let(:generic_work) { create(:generic_work, :with_image, :without_validations, staff_notes: ["this has some notes"]) }
  let(:solr_document) { SolrDocument.new(generic_work.to_solr) }
  let(:presenter) { Sufia::WorkShowPresenter.new(solr_document, ability) }

  context 'as a user with update ability' do
    before do
      allow(view).to receive(:can?).with(:update, SolrDocument).and_return(true)
      render 'curation_concerns/base/metadata', presenter: presenter
    end

    it 'shows the staff notes field' do
      expect(rendered).to have_content 'Staff notes'
    end
  end

  context 'as a user without update ability' do
    before do
      allow(view).to receive(:can?).with(:update, SolrDocument).and_return(false)
      render 'curation_concerns/base/metadata', presenter: presenter
    end

    it 'does not show the staff notes field' do
      expect(rendered).not_to have_content 'Staff notes'
    end
  end
end
